function [DATA,ratio] = HM_pair_function_read_data...
      (yr,mon,do_NpD,varname,method,do_rmdup,do_rmsml,env,do_connect_deck,do_other)

    % *******************
    % Input and Output **
    % *******************
    if ~exist('do_other','var'),
        % 1 means to connect Japanese Kobe collections
        do_other = 0;
    end

    if ~exist('env','var'),
        env = 1;             % 1 means on odyssey
    end

    if ~exist('do_connect_deck','var'),
        % 1 means to connect and correct for deck information
        do_connect_deck = 1;
    end
    dir_home = HM_OI('home',env);

    app = ['HM_',varname,'_',method];
    if app(end)=='_', app(end)=[]; end
    app(end+1) = '/';

    % *********************************
    % Set up file names to be read
    % *********************************
    dir_load = [HM_OI('read_raw',env),HM_OI('SST_raw')];
    clear('Pairs','Meta')
    clear('file_load','file_save','sst_ascii')
    cmon = CDF_num2str(mon,2);
    file_load = [dir_load,'IMMA1_R3.0.0_',num2str(yr),'-',cmon,'_QCed.mat'];
    file_load

    % *******************
    % READ IN THE DATA **
    % *******************
    try
        clear('logic','kind_temp','sst_ascii_temp')
        disp([file_load,' is started!']);

        if strcmp(varname,'SST')
            clear('C0_YR','C0_MO','C0_DY','C0_HR','C0_LCL','C0_UTC','C98_UID','C0_LON','C0_LAT',...
                'C1_DCK','C1_SID','C0_II','C1_PT','C0_SST','C0_OI_CLIM','C0_SI_1',...
                'C0_SI_2','C0_SI_3','C0_SI_4','QC_FINAL','C0_CTY_CRT','C1_DUPS','C0_IT')
            load (file_load,'C0_YR','C0_MO','C0_DY','C0_HR','C0_LCL','C0_UTC','C98_UID','C0_LON','C0_LAT',...
                'C1_DCK','C1_SID','C0_II','C1_PT','C0_SST','C0_OI_CLIM','C0_SI_1',...
                'C0_SI_2','C0_SI_3','C0_SI_4','QC_FINAL','C0_CTY_CRT','C1_DUPS','C0_IT')
            C0_OI_CLIM = double(C0_OI_CLIM);

            % -----------------------------------------------------------------
            clear('sst_ascii_temp','country_temp','dup_flag','DATA')
            sst_ascii_temp = [C0_YR;C0_MO;C0_DY;C1_DUPS;C0_LCL;C0_UTC;C98_UID;
                C0_LON;C0_LAT;C1_DCK;C1_SID;C0_II;C1_PT;
                C0_SST;C0_OI_CLIM;C0_SI_4;C0_SI_1;C0_SI_2;C0_SI_3];
            % 1. C0_YR;   2.C0_MO;    3.C0_DY;    4.C1_DUPS;
            % 5.C0_LCL;   6.C0_UTC;   7.C98_UID;    8.C0_LON;   9.C0_LAT;
            % 10.C1_DCK;  11.C1_SID;  12.C0_II;   13.C1_PT;
            % 14.C0_SST;  15.C0_OI_CLIM;
            % 16.C0_SI_4; 17.C0_SI_1; 18.C0_SI_2; 19.C0_SI_3
            % 20-21. Country
            sst_ascii_temp = sst_ascii_temp(:,QC_FINAL);
            country_temp = C0_CTY_CRT(QC_FINAL,:);
            DATA = [sst_ascii_temp; double(country_temp')];
            dup_flag  = C1_DUPS(QC_FINAL);
            clear('C0_YR','C0_MO','C0_DY','C0_HR','C0_LCL','C0_UTC','C98_UID','C0_LON','C0_LAT',...
                'C1_DCK','C1_SID','C0_II','C1_PT','C0_SST','C0_OI_CLIM','C0_SI_1',...
                'C0_SI_2','C0_SI_3','C0_SI_4','QC_FINAL','C0_CTY_CRT','C1_DUPS')
        end
        clear('sst_ascii_temp','country_temp')

        % *******************
        % Subset data      **
        % *******************
        if strcmp(varname,'SST'),
            if strcmp(method,'Bucket'),
                pick_limit = 0.05;
                logic_use = DATA(16,:) == 0 | ...
                    (DATA(16,:) > 0 & DATA(16,:) < pick_limit);
            end
        end
        l = ~ismember(DATA(10,:),[780 206 210 214 218 224 226 234 740 874]);
        logic_use = l & logic_use;
        ratio = [nnz(logic_use)  nnz(l)];
        DATA = DATA(:,logic_use);
        dup_flag = dup_flag(logic_use);

        % *********************************
        % Reassign deck information      **
        % *********************************
        clear('kind_cmp')
        id_nat = 20:21;
        id_dck = 10;
        kind_cmp = DATA([id_nat id_dck],:)';
        if do_connect_deck == 1,
            kind_cmp = HM_function_preprocess_deck(kind_cmp,1,do_other);
        end
        l_rm = ismember(kind_cmp,['US',732;'GB',732],'rows');
        DATA([id_nat id_dck],:) = kind_cmp';
        DATA(:,l_rm) = [];
        dup_flag(l_rm) = [];

        % *********************************
        % Remove duplication points      **
        % *********************************
        % Only one measurement is kept in the final version of ICOADS 3.0
        if do_rmdup == 1,
            DATA(:,dup_flag~=0) = [];
        end

        % ***********************************
        % Remove small contributing groups **
        % ***********************************
        if do_rmsml > 0,
            list_large_group = HM_pair_function_large_groups(do_NpD,varname,method,do_rmsml);

            if do_NpD == 0,
                l_use = ismember(DATA([id_nat],:)',list_large_group,'rows');
            else
                l_use = ismember(DATA([id_nat id_dck],:)',list_large_group,'rows');
            end

            DATA = DATA(:,l_use);
        end
    catch
        disp('error in reading the file ...')
        DATA = [];
    end
end
