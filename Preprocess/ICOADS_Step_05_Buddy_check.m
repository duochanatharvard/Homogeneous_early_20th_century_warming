% ICOADS_Step_05_Buddy_check(yr,mon)
%
% Finally, individual records are compared to the winsorized mean of individual pentad,
% and points that are three neighbor-wise standard deviations away
% from the winsorized mean do not pass buddy check. For points that grids
% that only have one measurements, the script spans out and search for neighbors
% in neighboring grids. The search spans out gradually from 1 up to 3 grids or pentads
% and the neighbors is the mean of all grids that have values.
% Measurement without a valid neighbor passes the quality control.
%
%
% Last update: 2018-08-15

function ICOADS_Step_05_Buddy_check(yr,mon)

    % Set direcotry of files  ---------------------------------------------
    dir_load_sst  = ICOADS_OI('pre_QC');
    dir_load_wm   = ICOADS_OI('WM');
    dir_save_qc   = ICOADS_OI('QCed');
    dir_buddy_std = ICOADS_OI('Mis');
    file_load_std_sst  = [dir_buddy_std,'Buddy_std_SST.mat'];
    file_load_std_nmat = [dir_buddy_std,'Buddy_std_NMAT.mat'];
    addpath('/n/home10/dchan/Matlab_Tool_Box/');
    addpath('/n/home10/dchan/m_map/');
    reso_s = 1;
    reso_t = 5;

    % Assign the file named to be used in this function -------------------
     [file_load_sst,file_load_wm,file_save_qc] = ...
                sst_function_step_004_files_ICOADS_re...
                        (yr,mon,dir_load_sst,dir_load_wm,dir_save_qc);

    std_key = 3;
    fid=fopen(file_load_sst,'r');

    if(fid~=-1)

        disp([file_load_sst ,' is started!']);
        fclose(fid);

        % #########################################################
        % For SST
        % #########################################################
        % Read Super Observation ------------------------------------------
        clear('WM_temp','NUM_temp')
        WM_temp = NaN(360/reso_s,180/reso_s,90/reso_t);
        NUM_temp = NaN(360/reso_s,180/reso_s,90/reso_t);
        for i=1:size(file_load_wm,1)
            ff = [file_load_wm(i,1:end-4),'_SST',file_load_wm(i,end-3:end)];
            ff
            fid=fopen(ff,'r');
            if(fid>0)
               clear('WM','NUM')
               fclose(fid);
               load(ff,'WM','NUM');
               WM_temp(1:360/reso_s,1:180/reso_s,(i-1)*(30/reso_t)+1:i*(30/reso_t))=WM;
               NUM_temp(1:360/reso_s,1:180/reso_s,(i-1)*(30/reso_t)+1:i*(30/reso_t))=NUM;
            end
        end
        clear('NUM','WM')
        WM_temp(NUM_temp == 1) = NaN;

        % Read SST data to be quality controlled --------------------------
        load(file_load_sst)

        % Read SST variance -----------------------------------------------
        load(file_load_std_sst)
        disp('Read Data Finish!')

        % Find Neighbours =================================================
        % Read Neighbours at this grid box --------------------------------
        nei_0 = re_function_general_grd2pnt(C0_LON,C0_LAT,C0_DY,WM_temp(:,:,7:12),reso_s,reso_s,reso_t);
        % Span out level 1 ------------------------------------------------
        nei_1 = sst_function_step_004_neighbour_ICOADS_re(1,C0_LON,C0_LAT,C0_DY,WM_temp,reso_s,reso_t);
        % Span out level 2 ------------------------------------------------
        nei_2 = sst_function_step_004_neighbour_ICOADS_re(2,C0_LON,C0_LAT,C0_DY,WM_temp,reso_s,reso_t);
        % Span out level 3 ------------------------------------------------
        nei_3 = sst_function_step_004_neighbour_ICOADS_re(3,C0_LON,C0_LAT,C0_DY,WM_temp,reso_s,reso_t);

        nei_1(isnan(nei_0)==0) = NaN;
        nei_2(isnan(nei_0)==0 | isnan(nei_1)==0) = NaN;
        nei_3(isnan(nei_0)==0 | isnan(nei_1)==0 | isnan(nei_2)==0) = NaN;
        C0_NB = nanmean([nei_0;nei_1;nei_2;nei_3],1);
        clear('nei_0','nei_1','nei_2','nei_3')

        % Compute the anomalies -------------------------------------------
        temp_sst = C0_SST - C0_OI_CLIM;

        % Read the standard deviation -------------------------------------
        std_qc = re_function_general_grd2pnt(C0_LON,C0_LAT,C0_MO,STD_save,1,1,1);
        std_qc(isnan(std_qc)) = 10;
        CD_STD_SST = std_qc;

        % Do the buddy check ==============================================
        clear('C0_QC_ME_2');
        C0_QC_ME_2 = abs((temp_sst - C0_NB)./std_qc) <= std_key;
        C0_QC_ME_2(isnan(C0_NB)) = 1;

        C0_QC_ME_1 = QC_NON_SST == 1 & (C0_SST > C0_OI_CLIM-10 & C0_SST < C0_OI_CLIM +10);
        C0_QC_ME_1(C0_SST > 37 | C0_SST < -5) = 0;
        C0_QC_ME_1(C1_SNC > 5) = 0;
        C0_QC_ME_1(C1_ZNC > 5 & C0_YR > 1859) = 0;

        QC_FINAL = C0_QC_ME_2 & C0_QC_ME_1;

        clear('temp_sst','std_qc','sp','nei_1','nei_2','nei_3','nei_0','nei_0_num','n','logic','k','i','j')
        clear('in_dy','file_load_sst','file_load_std_sst','fid','ans','a','WM_temp','STD_save','NUM_temp','file_save')
        clear('b','c','cmon','ct','dir_load_sst','dir_save_qc','file_save_pqc','mon')
        clear('nei_temp')

        % #########################################################
        % For NMAT
        % #########################################################
        % Read Super Observation ------------------------------------------
        clear('WM_temp','NUM_temp')
        WM_temp = NaN(360/reso_s,180/reso_s,90/reso_t);
        NUM_temp = NaN(360/reso_s,180/reso_s,90/reso_t);
        for i=1:size(file_load_wm,1)
            ff = [file_load_wm(i,1:end-4),'_NMAT',file_load_wm(i,end-3:end)];
            ff
            fid=fopen(ff,'r');
            if(fid>0)
               clear('WM','NUM')
               fclose(fid);
               load(ff,'WM','NUM');
               WM_temp(1:360/reso_s,1:180/reso_s,(i-1)*(30/reso_t)+1:i*(30/reso_t))=WM;
               NUM_temp(1:360/reso_s,1:180/reso_s,(i-1)*(30/reso_t)+1:i*(30/reso_t))=NUM;
            end
        end
        clear('NUM','WM')
        WM_temp(NUM_temp == 1) = NaN;

        % Read NMAT variance -----------------------------------------------
        load(file_load_std_nmat)
        disp('Read Data Finish!')

        % Find Neighbours =================================================
        % Read Neighbours at this grid box --------------------------------
        nei_0 = re_function_general_grd2pnt(C0_LON,C0_LAT,C0_DY,WM_temp(:,:,7:12),reso_s,reso_s,reso_t);
        % Span out level 1 ------------------------------------------------
        nei_1 = sst_function_step_004_neighbour_ICOADS_re(1,C0_LON,C0_LAT,C0_DY,WM_temp,reso_s,reso_t);
        % Span out level 2 ------------------------------------------------
        nei_2 = sst_function_step_004_neighbour_ICOADS_re(2,C0_LON,C0_LAT,C0_DY,WM_temp,reso_s,reso_t);
        % Span out level 3 ------------------------------------------------
        nei_3 = sst_function_step_004_neighbour_ICOADS_re(3,C0_LON,C0_LAT,C0_DY,WM_temp,reso_s,reso_t);

        nei_1(isnan(nei_0)==0) = NaN;
        nei_2(isnan(nei_0)==0 | isnan(nei_1)==0) = NaN;
        nei_3(isnan(nei_0)==0 | isnan(nei_1)==0 | isnan(nei_2)==0) = NaN;
        C0_NB_NMAT = nanmean([nei_0;nei_1;nei_2;nei_3],1);
        clear('nei_0','nei_1','nei_2','nei_3')

        % Do the buddy check ==============================================
        clear('C0_QC_ME_2_NMAT','C0_QC_ME_1_NMAT');
        C0_QC_ME_1_NMAT = QC_NON_AT == 1 & ((C0_AT > (C0_ERA_CLIM-10)) & (C0_AT < (C0_ERA_CLIM+10)));
        C0_QC_ME_1_NMAT(C1_ANC > 5) = 0;
        C0_QC_ME_1_NMAT(C1_ZNC > 5 & C0_YR > 1859) = 0;

        % Should exclude suez from deck 193 until 1893,
        % exclude deck 195 during WWII,
        % and exclude deck 780 platform 5 for all times.

        C0_QC_ME_1_NMAT(C1_DCK == 780 & C1_PT == 5) = 0;
        if yr >= 1942 && yr <= 1946,

            dir_era   = ICOADS_OI('Mis');
            dmat1 = load([dir_era,'/Dif_DMAT_NMAT_1929_1941.mat']);
            dmat2 = load([dir_era,'/Dif_DMAT_NMAT_1947_1956.mat']);

            corr1 = re_function_general_grd2pnt(C0_LON,C0_LAT,[],dmat1.Dif_DMAT_NMAT,5,5,1);
            corr2 = re_function_general_grd2pnt(C0_LON,C0_LAT,[],dmat2.Dif_DMAT_NMAT,5,5,1);
            corr = corr1 * (yr - 1941)/6 + corr2 * (1 - (yr - 1941)/6);

            C0_AT(C1_ND == 2) = C0_AT(C1_ND == 2) - corr(C1_ND == 2);
            C0_QC_ME_1_NMAT(C1_ND == 1) = 0;
            C0_QC_ME_1_NMAT(C1_DCK == 195) = 0;

        else

            if yr <= 1892, % Also need to throw away the deck 193,
                mask = zeros(72,36);
                mask([57:72],[27:29])     = 1;
                mask([71:72 1:9],[26:27]) = 1;
                mask([3:9],[17:26])       = 1;
                mask([10:19],[17:21])     = 1;
                mask([20:21],[17:19])     = 1;
                logic_bad_193 = re_function_general_grd2pnt(C0_LON,C0_LAT,[],mask,5,5,1);
                logic_remove  = C1_DCK == 193 & logic_bad_193 == 1;
                C0_QC_ME_1_NMAT(logic_remove) = 0;
            end

            C0_QC_ME_1_NMAT(C1_ND == 2) = 0;
        end

        % Compute the anomalies -------------------------------------------
        temp_sst = C0_AT - C0_ERA_CLIM;

        % Read the standard deviation -------------------------------------
        std_qc = re_function_general_grd2pnt(C0_LON,C0_LAT,C0_MO,STD_save,1,1,1);
        std_qc(isnan(std_qc)) = 10;
        CD_STD_NMAT = std_qc;

        C0_QC_ME_2_NMAT = abs((temp_sst - C0_NB_NMAT)./std_qc) <= std_key;
        C0_QC_ME_2_NMAT(isnan(C0_NB_NMAT)) = 1;

        QC_FINAL_NMAT = C0_QC_ME_2_NMAT & C0_QC_ME_1_NMAT;

        clear('temp_sst','std_qc','std_key','sp','nei_1','nei_2','nei_3','nei_0','nei_0_num','n','logic','k','i','j')
        clear('in_dy','file_load_sst','file_load_std_sst','file_load_std_nmat','fid','ans','a','WM_temp','STD_save','NUM_temp','file_save')
        clear('b','c','cmon','ct','dir_load_sst','dir_load_wm','dir_save_qc','file_load_wm','file_save_pqc','mon')
        clear('nei_temp','reso_s','reso_t','yr','dir_buddy_std','dir_load','dir_save','ff')

        save([file_save_qc],'-v7.3')
    else
        disp([file_load_sst ,' does not exist!']);
    end
    disp([file_save_qc ,' is finished!']);
    disp([' ']);
end

% -------------------------------------------------------------------------
function [file_load_sst,file_load_wm,file_save_qc] ...
              = sst_function_step_004_files_ICOADS_re ...
                    (yr,mon,dir_load_sst,dir_load_wm,dir_save_qc)

    clear('cmon')
    cmon = '00';
    cmon(end-size(num2str(mon),2)+1:end) = num2str(mon);
    file_load_sst = [dir_load_sst,'IMMA1_R3.0.0_',num2str(yr),'-',cmon,'_preQC.mat'];

    if (mon == 1)
        clear('cmon');        cmon = '12';
        file_load_wm(1,:) = [dir_load_wm,'IMMA1_R3.0.0_',num2str(yr-1),'-',cmon,'_WM.mat'];
    else
        clear('cmon');        cmon = '00';        cmon(end-size(num2str(mon-1),2)+1:end) = num2str(mon-1);
        file_load_wm(1,:) = [dir_load_wm,'IMMA1_R3.0.0_',num2str(yr),'-',cmon,'_WM.mat'];
    end

    clear('cmon');    cmon = '00';    cmon(end-size(num2str(mon),2)+1:end) = num2str(mon);
    file_load_wm(2,:) = [dir_load_wm,'IMMA1_R3.0.0_',num2str(yr),'-',cmon,'_WM.mat'];

    if (mon == 12)
        clear('cmon');        cmon = '01';
        file_load_wm(3,:) = [dir_load_wm,'IMMA1_R3.0.0_',num2str(yr+1),'-',cmon,'_WM.mat'];
    else
        clear('cmon');        cmon = '00';        cmon(end-size(num2str(mon+1),2)+1:end) = num2str(mon+1);
        file_load_wm(3,:) = [dir_load_wm,'IMMA1_R3.0.0_',num2str(yr),'-',cmon,'_WM.mat'];
    end

    clear('cmon');    cmon = '00';    cmon(end-size(num2str(mon),2)+1:end) = num2str(mon);
    file_save_qc = [dir_save_qc,'IMMA1_R3.0.0_',num2str(yr),'-',cmon,'_QCed.mat'];
end

% -------------------------------------------------------------------------
function nei = sst_function_step_004_neighbour_ICOADS_re ...
                        (sp,C0_LON,C0_LAT,C0_DY,WM_temp,reso_s,reso_t)

    ct = 0;
    clear('nei_temp')
    for i = [-sp:sp]
        for j = [-sp:sp]
            for k = [-sp:sp]
                if(sum(abs([i,j,k])) == sp)
                    ct = ct+1;
                    nei_temp(ct,:) = re_function_general_grd2pnt...
                        (C0_LON+i*reso_s,C0_LAT+j*reso_s,C0_DY,WM_temp(:,:,[7:12]+k),reso_s,reso_s,reso_t);
                end
            end
        end
    end
    nei = nanmean(nei_temp,1);
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
