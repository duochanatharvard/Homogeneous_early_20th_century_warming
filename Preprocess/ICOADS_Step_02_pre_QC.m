% ICOADS_Step_02_pre_QC(yr, mon)
%
%
%  This function takes in the converted Matlab mat files, and do the following step:
%
%  a. Convert Country from number into 2 letter abbreviation
%     also convert nations according to Callsigns, and from ID of 705-707
%
%  b. Assign Country name according to deck information,
%  a list can be found in Table.1 in __Chan and Huybers (2019)__.
%
%  c. Convert WMO47 SST measurement method into
%  ICOADS IMMA SST measurement method (SI) format.
%
%  d. Assign SST measurement method to records
%  with missing values following __Kennedy et. al. (2011)__.
%
%  e. Assign 1982-2014 climatology from OI-SST (__Reynolds, 1993__),
%  local time (starting from 0:30am - 1:30am), universal time (hours since 0001-01-01).
%
%  f. Flag records that have valid year, month, day, longitude, latitude, and SST.
%
%  Note that this function only flags but do not throw away any measurements.
%
%
% Last update: 2018-10-13

% historical comments: It worth notice that in this version II that are 6 and 7 are treated as
% ship measurements. The local time is 0.51 - 1.5 saved as 1, and 1.51 -
% 2.5 saved as 2, and so on ...

function ICOADS_Step_02_pre_QC(yr,mon)

    % Set direcotry of files  ---------------------------------------------
    dir_load  = ICOADS_OI('mat_files');
    dir_save  = ICOADS_OI('pre_QC');
    dir_OI    = ICOADS_OI('Mis');
    cmon = '00';  cmon(end-size(num2str(mon),2)+1:end) = num2str(mon);
    file_load_pqc = [dir_load,'IMMA1_R3.0.0_',num2str(yr),'-',cmon,'.mat'];
    file_save_pqc = [dir_save,'IMMA1_R3.0.0_',num2str(yr),'-',cmon,'_preQC.mat'];

    % Process the data   --------------------------------------------------

    fid = fopen(file_load_pqc,'r');

    if fid > 0,
        fclose(fid);
        load(file_load_pqc);

        % Convert Country # into 2 letter abbreviation --------------------
        C0_ID_CTY = ICOADS_callsign2nation(C0_ID,C0_II);
        C0_ID_CTY(isnan(C0_ID_CTY)) = 32;
        C0_ID_CTY = char(C0_ID_CTY);
        % --------------------------------------
        C0_USM_CTY = char(ones(size(C0_C1))*32);
        l_usm = ismember(C1_DCK,[705 706 707]);
        C0_USM_CTY(l_usm,1:2) = C0_ID(l_usm,1:2);
        % --------------------------------------
        C0_CTY_RAW = sst_function_step_001_nation_ICOADS_re(C0_C1,C1_C2,C7_C1M);
        % --------------------------------------
        C0_CTY_MID = C0_CTY_RAW;
        l = all(C0_CTY_MID == 32,2);
        C0_CTY_MID(l,:) = C0_ID_CTY(l,:);
        C0_CTY = C0_CTY_MID;
        l = all(C0_CTY == 32,2);
        C0_CTY(l,:) = C0_USM_CTY(l,:);

        % Assign Country name according to deck ---------------------------
        C0_CTY_CRT = sst_function_step_001_deck_nation_ICOADS_re(C0_CTY,C1_DCK);

        % Convert WMO47 into Measurement Method code ----------------------
        C7_WMOMM = sst_function_step_001_wmo_ICOADS_re(C7_SIM);

        % Assign SST method following Kennedy 2011 ------------------------
        [C0_SI_0,C0_SI_1,C0_SI_2,C0_SI_3,C0_SI_4] = ...
                sst_function_step_001_SST_method_ICOADS_re ...
                (C0_SI,C0_YR,C1_DCK,C1_SID,C0_II,C7_WMOMM,C0_CTY_CRT,C1_PT);

        % Assign climatology, local time, universial time, and nan flag ---
        [C0_OI_CLIM,C0_LCL,C0_LCL_raw,C0_UTC,QC_NON_SST] = ...
                sst_function_step_001_OI_SST_ICOADS_re ...
                (C0_YR,C0_MO,C0_DY,C0_HR,C0_SST,C0_LON,C0_LAT,dir_OI);

        [C0_ERA_CLIM,QC_NON_AT] = ...
                 sst_function_step_001_OI_NMAT_ICOADS_re ...
                 (C0_YR,C0_MO,C0_DY,C0_HR,C0_AT,C0_LON,C0_LAT,dir_OI);

        clear('dir_OI','fid','file_load','file_load_pqc','file_save');
        disp(['Saving ', file_save_pqc,' ...'])
        save(file_save_pqc,'-v7.3');

    else
        disp('No Data In this Year!')
    end

end

% -------------------------------------------------------------------------
function C0_CTY = sst_function_step_001_nation_ICOADS_re(C0_C1,C1_C2,C7_C1M)

    disp('Preprocessing Nation Names ...');

    % Assgin name list of nations -----------------------------------------
    num_list = {'00','01','02','03','04','05','06','07','08','09',...
        ' 0',' 1',' 2',' 3',' 4',' 5',' 6',' 7',' 8',' 9'};
    for i = 10:40
        num_list{11+i} = num2str(i);
    end
    country_list = {'NL','NO','US','GB','FR','DK','IT','IN','HK','NZ',...
        'NL','NO','US','GB','FR','DK','IT','IN','HK','NZ',...
        'IE','PH','EG','CA','BE','ZA','AU','JP','PK','AR',...
        'SE','DE','IS','IL','MY','RU','FI','KR','NC','PT',...
        'ES','TH','MK','PL','BR','SG','KE','TZ','UG','MX','DD'};

    % Convert Nation Number into Abbreviations ----------------------------
    for i=1:numel(num_list)
        logic = C0_C1(:,1) == num_list{i}(1) & C0_C1(:,2) == num_list{i}(2);
        C0_C1(logic,:) = repmat(country_list{i},nnz(logic),1);

        logic = C1_C2(:,1) == num_list{i}(1) & C1_C2(:,2) == num_list{i}(2);
        C1_C2(logic,:) = repmat(country_list{i},nnz(logic),1);

        logic = C7_C1M(:,1) == num_list{i}(1) & C7_C1M(:,2) == num_list{i}(2);
        C7_C1M(logic,:) = repmat(country_list{i},nnz(logic),1);
    end

    % Assign Recruiting Nation from difference sources --------------------
    logic_1 = (C0_C1(:,1) == ' ' & C0_C1(:,2) == ' ') ==0;
    logic_2 = (C1_C2(:,1) == ' ' & C1_C2(:,2) == ' ') ==0;
    logic_3 = (C7_C1M(:,1) == ' ' & C7_C1M(:,2) == ' ') ==0;
    C0_CTY = repmat('  ',size(C0_C1,1),1);
    C0_CTY(logic_1,:) = C0_C1(logic_1,:);
    C0_CTY(logic_1 == 0 & logic_3,:) = C1_C2(logic_1 == 0 & logic_3,:);
    C0_CTY(logic_1 == 0 & logic_3 == 0 & logic_2,:) = C7_C1M(logic_1 == 0 & logic_3 == 0 & logic_2,:);

    disp('Preprocessing Nation Names Completes!');
    disp(' ')
end

% -------------------------------------------------------------------------
function C0_CTY_CRT = sst_function_step_001_deck_nation_ICOADS_re(C0_CTY,C1_DCK)

    disp('Assgining Nation Names using DCK ...');

    C0_CTY_CRT = C0_CTY;
    logic0 = (C0_CTY(:,1) == ' ' & C0_CTY(:,2) == ' ')';

    % 1. Netherlands ------------------------------------------------------
    clear('logic')
    logic = ismember(C1_DCK,[150;189;193]) & logic0;
    C0_CTY_CRT(logic,:) = repmat('NL',nnz(logic),1);
    % 2. US ---------------------------------------------------------------
    clear('logic')
    logic = ismember(C1_DCK,[110 116 117 195 218 281 666 667 701 703 704 709 710]) & logic0;
    C0_CTY_CRT(logic,:) = repmat('US',nnz(logic),1);
    % 3. UK ---------------------------------------------------------------
    clear('logic')
    logic = ismember(C1_DCK,[152 184 194 902 204 205 211 216 229 239 245 248 249]) & logic0;
    C0_CTY_CRT(logic,:) = repmat('GB',nnz(logic),1);
    % 4. Japan ------------------------------------------------------------
    clear('logic')
    logic = ismember(C1_DCK,[118 119 187 761 762 898]) & logic0;
    C0_CTY_CRT(logic,:) = repmat('JP',nnz(logic),1);
    % 5. Russia -----------------------------------------------------------
    clear('logic')
    logic = ismember(C1_DCK,[185 186 732 731 733 735]) & logic0;
    C0_CTY_CRT(logic,:) = repmat('RU',nnz(logic),1);
    % 6. German ------------------------------------------------------
    clear('logic')
    logic = ismember(C1_DCK,[151 192 196 215 715 720 721 772 850]) & logic0;
    C0_CTY_CRT(logic,:) = repmat('DE',nnz(logic),1);
    % 7. Norway -----------------------------------------------------------
    clear('logic')
    logic = ismember(C1_DCK,[188 702 225]) & logic0;
    C0_CTY_CRT(logic,:) = repmat('NO',nnz(logic),1);
    % 8. Canada -----------------------------------------------------------
    clear('logic')
    logic = ismember(C1_DCK,[714]) & logic0;
    C0_CTY_CRT(logic,:) = repmat('CA',nnz(logic),1);
    % 9. South Africa -----------------------------------------------------
    clear('logic')
    logic = ismember(C1_DCK,[899]) & logic0;
    C0_CTY_CRT(logic,:) = repmat('ZA',nnz(logic),1);
    % 10. Australia -------------------------------------------------------
    clear('logic')
    logic = ismember(C1_DCK,[900 750]) & logic0;
    C0_CTY_CRT(logic,:) = repmat('AU',nnz(logic),1);

    disp('Assgining Nation Names using DCK Completes!');
    disp(' ')
end

% -------------------------------------------------------------------------
function C7_WMOMM = sst_function_step_001_wmo_ICOADS_re(C7_SIM)

    disp('Converting WMO No47 Metadata ...');

    % Assign name list of measurement methods -----------------------------
    mm_list = {'BU ','C  ','HC ','HT ','RAD','TT ','OT ','BTT'};
    mm_num  = [ 0     1     3     4     5     2     -1     6   ];

    clear('C7_WMOMM');
    C7_WMOMM  = ones (1,size(C7_SIM,1)) * -1;

    % Convert WMO47 into measurement numbers ------------------------------
    for m = 1:size(mm_list,2)
        clear('logic');
        logic = C7_SIM(:,1) == mm_list{m}(1) & C7_SIM(:,2) == mm_list{m}(2) & C7_SIM(:,3) == mm_list{m}(3);
        C7_WMOMM (logic) = mm_num(m);
    end

    disp('Converting WMO No47 Metadata Compeletes!');
    disp(' ');
end

% -------------------------------------------------------------------------
function [C0_SI,C0_SI_1,C0_SI_2,C0_SI_3,C0_SI_4] = ...
          sst_function_step_001_SST_method_ICOADS_re ...
                (C0_SI,C0_YR,C1_DCK,C1_SID,C0_II,C7_WMOMM,C0_CTY_CRT,C1_PT)

    disp('Assigning SST measurement methods ...');

    % 0 Pretreatment: Assign -1 -------------------------------------------
    C0_SI(isnan(C0_SI)) = -1;

    % 1. Assign C-MAN -----------------------------------------------------
    logic_cman = (C1_DCK == 795 | C1_DCK == 995) | C0_II == 5 | C1_PT  == 13;

    % 2 Assign Buoy Measurement -------------------------------------------
    kind_buoy_list = [3 4 11]';
    source_buoy_list = [24 55 50 61 62 63 66 86 87 117 118 120 121 122 139 147 169 170]';
    deck_buoy_list = [143 144 146 714 734 793 794 876 877 878 879 880 881 882 883 893 894 993 994 235]';
    plt_buoy_list  = [6 7 8];

    clear('logic_kind_buoy','logic_deck_buoy','logic_source_buoy','logic_plt_buoy')
    logic_kind_buoy   = ismember(C0_II,kind_buoy_list);
    logic_source_buoy = ismember(C1_SID,source_buoy_list);
    logic_deck_buoy   = ismember(C1_DCK,deck_buoy_list);
    logic_plt_buoy    = ismember(C1_PT,plt_buoy_list);
    logic_buoy = logic_kind_buoy | logic_source_buoy | logic_deck_buoy | logic_plt_buoy;

    % 3. Before 1941, All ships were bucket unless specified --------------
    logic_ship = ismember(C0_II,[1 2 8 9 10]) | ismember(C1_PT,[0 1 2 3 4 5]) | isnan(C0_II);
    logic_bucket = logic_ship & ((C0_YR < 1941 & C0_SI == -1) | C0_SI == 10);

    C0_SI_1 = C0_SI;
    C0_SI_1(logic_bucket) = 0;
    C0_SI_1(logic_buoy & ~logic_cman) = -2;
    C0_SI_1(logic_cman)   = -3;

    % 4. From 1956, using WMO No 47. Meta-data by ship tracks -------------
    C0_SI_2 = C0_SI_1;
    C7_WMOMM(isnan(C7_WMOMM)) = -1;
    logic_wmo = logic_ship & (C0_SI_1 == -1 | C0_SI_1 == 7 | C0_SI_1 == 9) & ...
                ~(C7_WMOMM == -1 | C7_WMOMM == 7 | C7_WMOMM == 9);
    C0_SI_2(logic_wmo) = C7_WMOMM(logic_wmo);

    % 5. US ships after 1944 and GB royal are ERI -------------------------
    C0_SI_3 = C0_SI_2;
    logic_US = logic_ship & C0_SI_2 == -1 & C0_CTY_CRT(:,1)' == 'U' & C0_CTY_CRT(:,2)' == 'S' & C0_YR > 1944;
    logic_royal = logic_ship & C1_DCK == 245 & (C0_SI_2 == -1 | C0_YR > 1941);
    C0_SI_3 (logic_US | logic_royal) = 1;

    % 5. Assign Ships Based on nations ------------------------------------
    if (C0_YR(1) > 1940)
        percent = [ 0.9619    0.0225    0.9953    1.0000    1.0000    0.9848
                    0.9728    0.0257    0.9923    0.9862    1.0000    0.9687
                    0.9821    0.0268    0.9783    0.9536    1.0000    0.9546
                    0.9877    0.0190    0.9647    0.9214    1.0000    0.9405
                    0.9936    0.0170    0.9523    0.8862    1.0000    0.9258
                    0.9901    0.0189    0.9435    0.8561    1.0000    0.9169
                    0.9871    0.0181    0.9309    0.8121    1.0000    0.9057
                    0.9844    0.0153    0.9352    0.7727    1.0000    0.9035
                    0.9834    0.0120    0.9393    0.7474    1.0000    0.9063
                    0.9753    0.0083    0.9368    0.7188    1.0000    0.9038
                    0.9627    0.0058    0.9262    0.6770    1.0000    0.8971
                    0.9516    0.0043    0.9176    0.6412    1.0000    0.8871
                    0.9422    0.0041    0.9073    0.5824    1.0000    0.8688
                    0.9194    0.0046    0.8914    0.5062    1.0000    0.8399
                    0.9084    0.0059    0.8747    0.4357    1.0000    0.8210
                    0.9136    0.0121    0.8831    0.3674    1.0000    0.8377
                    0.9150    0.0185    0.8890    0.3052    1.0000    0.8623
                    0.9107    0.0192    0.8921    0.2583    1.0000    0.8791
                    0.9232    0.0141    0.9024    0.2320    1.0000    0.9150
                    0.9247    0.0120    0.9177    0.1893    1.0000    0.9420
                    0.9037    0.0116    0.9092    0.1486    1.0000    0.9413
                    0.8845    0.0130    0.9035    0.1227    0.7437    0.9373
                    0.8629    0.0149    0.9033    0.1066    0.3612    0.9454
                    0.8348    0.0168    0.8980    0.0789    0.1006    0.9418
                    0.8089    0.0166    0.8950    0.0732    0.0931    0.9458
                    0.7892    0.0162    0.8956    0.0725    0.0626    0.9485
                    0.7606    0.0160    0.8993    0.0667    0.0247    0.9527
                    0.7327    0.0161    0.9008    0.0569         0    0.9582
                    0.6987    0.0170    0.9025    0.0504         0    0.9634
                    0.6662    0.0200    0.9009    0.0393         0    0.9661
                    0.6380    0.0227    0.8996    0.0304         0    0.9691
                    0.6648    0.0227    0.8950    0.0250    0.0407    0.9699
                    0.6971    0.0221    0.8878    0.0269    0.1079    0.9181
                    0.7399    0.0255    0.8813    0.0261    0.1585    0.8817
                    0.7788    0.0304    0.8717    0.0320    0.1656    0.8395
                    0.8154    0.0334    0.8520    0.0334    0.1677    0.7989
                    0.8058    0.0356    0.8324    0.0426    0.1680    0.7588
                    0.7033    0.0404    0.8093    0.0465    0.1600    0.7799
                    0.5909    0.0453    0.7885    0.0510    0.1416    0.7870
                    0.4862    0.0475    0.7691    0.0535    0.1252    0.8000
                    0.3842    0.0475    0.7601    0.0573    0.1187    0.8113
                    0.2840    0.0475    0.7395    0.0550    0.1187    0.8225
                    0.2778    0.0465    0.7209    0.0501    0.1187    0.8239
                    0.2834    0.0445    0.6956    0.0519    0.1187    0.8239
                    0.2860    0.0428    0.6650    0.0506    0.1187    0.8239
                    0.2869    0.0423    0.6228    0.0505    0.1187    0.8138
                    0.2813    0.0424    0.5772    0.0487    0.0994    0.7789
                    0.2689    0.0424    0.5283    0.0463    0.0642    0.7153
                    0.2470    0.0365    0.4777    0.0417    0.0354    0.6305
                    0.2266    0.0269    0.4305    0.0365    0.0290    0.5314
                    0.2026    0.0170    0.3874    0.0313    0.0289    0.4114
                    0.1915    0.0075    0.3554    0.0242    0.0289    0.3284];

        if (C0_YR(1) > 1940 && C0_YR(1) < 1957)
            percent = 1 - percent(1,:);
        elseif(C0_YR(1) > 1956)
            percent = 1 - percent(min(C0_YR(1)-1955,size(percent,1)),:);
        end
        percent(7) = percent(6);
        C0_SI_4 = C0_SI_3;
        cty_list = {'NL','US','UK','JP','RU','DD','DE'};
        for i = 1:size(cty_list,2)
            logic = C0_CTY_CRT(:,1)' == cty_list{i}(1) & C0_CTY_CRT(:,2)' == ...
                                cty_list{i}(2) & logic_ship & C0_SI_3 == -1;
            C0_SI_4(logic) = percent(i);
        end
    else
        C0_SI_4 = C0_SI_3;
    end

    disp('Assigning SST measurement methods Compeletes!');
    disp(' ');
end

% -------------------------------------------------------------------------
function [C0_OI_CLIM,C0_LCL,C0_LCL_raw,C0_UTC,QC_NON_SST] = ...
         sst_function_step_001_OI_SST_ICOADS_re ...
                    (C0_YR,C0_MO,C0_DY,C0_HR,C0_SST,C0_LON,C0_LAT,dir_OI)

    disp('Assigning OI-SST ...');

    % Assign UTC and Local Time -------------------------------------------
    C0_LCL_raw = rem(C0_HR + C0_LON./15 ,24);

    C0_LCL = rem(C0_HR + C0_LON./15, 24);
    C0_LCL (C0_LCL < 0.501) = C0_LCL (C0_LCL < 0.501) + 24;
    C0_LCL = fix(C0_LCL - 0.501) + 1;
    C0_LCL (C0_LCL < 1) = C0_LCL (C0_LCL < 1) + 24;
    C0_LCL (C0_LCL > 24) = C0_LCL (C0_LCL > 24) - 24;

    C0_UTC = (datenum([C0_YR', C0_MO', C0_DY'])'-1)*24 + C0_HR;

    % Assign OI-SST Climatology -------------------------------------------
    load ([dir_OI,'OI_clim_1982_2014.mat'])
    OI_clim(abs(OI_clim)>1000) = NaN;
    in_dy = datenum([ones(size(C0_YR))' C0_MO' C0_DY'])' - 366;
    in_dy(in_dy>365) = 365;

    % addpath('/n/home10/dchan/script/Peter/ICOAD_RE/function/'); ---------
    clear('C0_OI_CLIM')
    C0_OI_CLIM = re_function_general_grd2pnt(C0_LON,C0_LAT,in_dy,OI_clim,0.25,0.25,1);

    % Find Surrounding Points: level 1 ------------------------------------
    clear('temp','C0_temp')
    C0_temp(1,:) = re_function_general_grd2pnt(C0_LON+0.25,C0_LAT,in_dy,OI_clim,0.25,0.25,1);
    C0_temp(2,:) = re_function_general_grd2pnt(C0_LON-0.25,C0_LAT,in_dy,OI_clim,0.25,0.25,1);
    temp = nanmean(C0_temp,1);
    C0_OI_CLIM(isnan(C0_OI_CLIM)) = temp(isnan(C0_OI_CLIM));

    % Find Surrounding Points: level 2 ------------------------------------
    clear('temp','C0_temp')
    C0_temp(1,:) = re_function_general_grd2pnt(C0_LON+0.5,C0_LAT,in_dy,OI_clim,0.25,0.25,1);
    C0_temp(2,:) = re_function_general_grd2pnt(C0_LON-0.5,C0_LAT,in_dy,OI_clim,0.25,0.25,1);
    C0_temp(3,:) = re_function_general_grd2pnt(C0_LON,min(C0_LAT+0.25,90),in_dy,OI_clim,0.25,0.25,1);
    C0_temp(4,:) = re_function_general_grd2pnt(C0_LON,max(C0_LAT-0.25,-90),in_dy,OI_clim,0.25,0.25,1);
    temp = nanmean(C0_temp,1);
    C0_OI_CLIM(isnan(C0_OI_CLIM)) = temp(isnan(C0_OI_CLIM));

    % Find Surrounding Points: level 3 ------------------------------------
    clear('temp','C0_temp')
    C0_temp(1,:) = re_function_general_grd2pnt(C0_LON+0.75,C0_LAT,in_dy,OI_clim,0.25,0.25,1);
    C0_temp(2,:) = re_function_general_grd2pnt(C0_LON-0.75,C0_LAT,in_dy,OI_clim,0.25,0.25,1);
    C0_temp(3,:) = re_function_general_grd2pnt(C0_LON+0.25,min(C0_LAT+0.25,90),in_dy,OI_clim,0.25,0.25,1);
    C0_temp(4,:) = re_function_general_grd2pnt(C0_LON+0.25,max(C0_LAT-0.25,-90),in_dy,OI_clim,0.25,0.25,1);
    C0_temp(5,:) = re_function_general_grd2pnt(C0_LON-0.25,min(C0_LAT+0.25,90),in_dy,OI_clim,0.25,0.25,1);
    C0_temp(6,:) = re_function_general_grd2pnt(C0_LON-0.25,max(C0_LAT-0.25,-90),in_dy,OI_clim,0.25,0.25,1);
    temp = nanmean(C0_temp,1);
    C0_OI_CLIM(isnan(C0_OI_CLIM)) = temp(isnan(C0_OI_CLIM));

    % Find Surrounding Points: level 4 ------------------------------------
    clear('temp','C0_temp')
    C0_temp(1,:) = re_function_general_grd2pnt(C0_LON+1,C0_LAT,in_dy,OI_clim,0.25,0.25,1);
    C0_temp(2,:) = re_function_general_grd2pnt(C0_LON-1,C0_LAT,in_dy,OI_clim,0.25,0.25,1);
    C0_temp(3,:) = re_function_general_grd2pnt(C0_LON,min(C0_LAT+0.5,90),in_dy,OI_clim,0.25,0.25,1);
    C0_temp(4,:) = re_function_general_grd2pnt(C0_LON,max(C0_LAT-0.5,-90),in_dy,OI_clim,0.25,0.25,1);
    C0_temp(5,:) = re_function_general_grd2pnt(C0_LON+0.5,min(C0_LAT+0.25,90),in_dy,OI_clim,0.25,0.25,1);
    C0_temp(6,:) = re_function_general_grd2pnt(C0_LON+0.5,max(C0_LAT-0.25,-90),in_dy,OI_clim,0.25,0.25,1);
    C0_temp(7,:) = re_function_general_grd2pnt(C0_LON-0.5,min(C0_LAT+0.25,90),in_dy,OI_clim,0.25,0.25,1);
    C0_temp(8,:) = re_function_general_grd2pnt(C0_LON-0.5,max(C0_LAT-0.25,-90),in_dy,OI_clim,0.25,0.25,1);
    temp = nanmean(C0_temp,1);
    C0_OI_CLIM(isnan(C0_OI_CLIM)) = temp(isnan(C0_OI_CLIM));

    C0_OI_CLIM = double(C0_OI_CLIM);

    % Exclude non SST, time or space --------------------------------------
    QC_NON_SST = isnan(C0_YR) | isnan(C0_MO) | isnan(C0_DY) | isnan(C0_SST) |...
        isnan(C0_LON) | isnan(C0_LAT) | isnan(C0_OI_CLIM);
    QC_NON_SST = ~QC_NON_SST;

    disp('Assigning OI-SST Complete!');
    disp(' ');
end

% -------------------------------------------------------------------------
function [C0_ERA_CLIM,QC_NON_AT] = ...
         sst_function_step_001_OI_NMAT_ICOADS_re ...
                    (C0_YR,C0_MO,C0_DY,C0_HR,C0_AT,C0_LON,C0_LAT,dir_OI)

    disp('Assigning ERA_interim AT...');

    % Assign OI-SST Climatology -------------------------------------------
    load ([dir_OI,'ERA_interim_AT2m_1985_2014_daily_climatology.mat'])  % unit: K
    t2m_clim_smooth = t2m_clim_smooth - 273.15;
    t2m_clim_smooth(abs(t2m_clim_smooth)>1000) = NaN;
    in_dy = datenum([ones(size(C0_YR))' C0_MO' C0_DY'])' - 366;
    in_dy(in_dy>365) = 365;

    % addpath('/n/home10/dchan/script/Peter/ICOAD_RE/function/'); ---------
    clear('C0_ERA_CLIM')
    C0_ERA_CLIM = re_function_general_grd2pnt(C0_LON,C0_LAT,in_dy,t2m_clim_smooth,0.25,0.25,1);

    C0_ERA_CLIM = double(C0_ERA_CLIM);

    % Exclude non SST, time or space --------------------------------------
    QC_NON_AT = isnan(C0_YR) | isnan(C0_MO) | isnan(C0_DY) | isnan(C0_AT) |...
        isnan(C0_LON) | isnan(C0_LAT) | isnan(C0_ERA_CLIM);
    QC_NON_AT = ~QC_NON_AT;

    disp('Assigning ERA_interim AT Complete!');
    disp(' ');
end

% -------------------------------------------------------------------------
function out_pnts = re_function_general_grd2pnt(in_lon,in_lat,...
                                        in_dy,in_grd,reso_x,reso_y,reso_t)

    in_lon = rem(in_lon + 360*5, 360);
    x = fix(in_lon/reso_x)+1;
    num_x = 360/reso_x;
    x(x>num_x) = x(x>num_x) - num_x;

    in_lat(in_lat>90) = 90;
    in_lat(in_lat<-90) = -90;
    y = fix((in_lat+90)/reso_y) +1;
    num_y = 180/reso_y;
    y(y>num_y) = num_y;

    if(isempty(in_dy))
        index = sub2ind(size(in_grd),x,y);
    else
        z = min(fix((in_dy-0.01)./reso_t)+1,size(in_grd,3));
        index = sub2ind(size(in_grd),x,y,z);
    end

    out_pnts = in_grd (index);
    out_pnts(abs(out_pnts)>1e8) = NaN;
end
