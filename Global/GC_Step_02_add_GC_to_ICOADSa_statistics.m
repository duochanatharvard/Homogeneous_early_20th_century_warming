% This code add global correction of statistics to
% 1000 members of random regional bucket corrections.
% Uncertainty of global correction is taken from HadSST3.

clear;

% *****************
% Set parameters **
% *****************
do_idv = 0;              % For mean correction, when equals to zero, random correction
do_NpD = 1;
EP.do_rmdup = 0;
EP.do_rmsml = 0;
EP.sens_id  = 0;
EP.do_fewer_first = 0;
EP.connect_kobe   = 1;
EP.do_add_JP = 0;
EP.yr_start = 1850;

% ********************************
% Load regional correction
% ********************************
env = 0;
dir_home = HM_OI('home',env);
dir_load = [dir_home,'HM_SST_Bucket/'];
if do_idv == 1;
    file_load = [dir_load,'SUM_corr_idv_HM_SST_Bucket_deck_level_',...
                          num2str(do_NpD),'_do_rmdup_',num2str(EP.do_rmdup),...
                          '_correct_kobe_',num2str(EP.do_add_JP),...
                          '_connect_kobe_',num2str(EP.connect_kobe),...
                              '_yr_start_',num2str(EP.yr_start),'.mat'];
else
    file_load = [dir_load,'SUM_corr_rnd_HM_SST_Bucket_deck_level_',...
                          num2str(do_NpD),'_do_rmdup_',num2str(EP.do_rmdup),...
                          '_correct_kobe_',num2str(EP.do_add_JP),...
                          '_connect_kobe_',num2str(EP.connect_kobe),...
                              '_yr_start_',num2str(EP.yr_start),'.mat'];
end
load(file_load)

% ********************************
% Load global correction
% ********************************
start_ratio = 35;
mass_small = 0.65;
mass_large = 1.7;
app = ['start_ratio_',num2str(start_ratio),'_mass_small_',num2str(mass_small),...
    '_mass_large_',num2str(mass_large),'_start_ratio_',num2str(start_ratio)];
dir_GC = HM_OI('Global_correction',env);
file_GC = [dir_GC,'Global_Bucket_Correction_',app,'.mat'];
load(file_GC,'Corr_save')

% ****************************************************************
% Compute statistics for the global correction
% ****************************************************************
MASK = HM_function_mask_JP_NA;
[GC_trd,GC_TS,GC_pdo,GC_pdo_int,GC_TS_coastal] = HM_function_postprocess_step12(-Corr_save,...
                                -Corr_save(:,:,:,[1908:1941]-1849),MASK,env);

% ****************************************************************
% Compute uncertainty of statistics of global correction from HadSST3
% ****************************************************************
dir_mis  = HM_OI('Mis',env);
file_mis = [dir_mis,'1908_1941_Trd_TS_and_pdo_from_all_existing_datasets_20180914.mat'];
load(file_mis,'hadsst3','hadsst3_en');

%% ****************************************************************
% Merging GC to RC
% ****************************************************************
if do_idv == 1,
    Main_trd = Main_trd + repmat(GC_trd,1,1,2);
    Main_TS  = Main_TS  + repmat(GC_TS,1,1,1,2);
    Main_TS_coastal  = Main_TS_coastal  + repmat(GC_TS_coastal, 1,1,1,2);
    Main_pdo = Main_pdo + repmat(GC_pdo,2,1);
    Main_pdo_int = Main_pdo_int + repmat(GC_pdo',1,2,2);

    N = size(Save_trd,3);
    Save_trd = Save_trd + repmat(GC_trd,1,1,N);
    Save_TS  = Save_TS  + repmat(GC_TS, 1,1,1,N);
    Save_TS_coastal  = Save_TS_coastal  + repmat(GC_TS_coastal, 1,1,1,N);
    Save_pdo = Save_pdo + repmat(GC_pdo,N,1);
    Save_pdo_int = Save_pdo_int + repmat(GC_pdo',1,2,N);

    file_save = [dir_load,'SUM_corr_idv_HM_SST_Bucket_deck_level_1_GC',...
                          '_do_rmdup_',num2str(EP.do_rmdup),...
                          '_correct_kobe_',num2str(EP.do_add_JP),...
                          '_connect_kobe_',num2str(EP.connect_kobe),...
                          '_yr_start_',num2str(EP.yr_start),'.mat'];
    save(file_save,'Main_trd','Main_TS','Main_TS_coastal','Main_pdo','Main_pdo_int',...
                   'Save_trd','Save_TS','Save_TS_coastal','Save_pdo','Save_pdo_int','-v7.3')
else

    rnd_trd = repmat(hadsst3_en.trd,1,1,10) - repmat(hadsst3.trd,1,1,1000);
    rnd_TS  = repmat(hadsst3_en.ts,1,1,1,10) - repmat(hadsst3.ts,1,1,1,1000);
    rnd_TS_coastal  = repmat(hadsst3_en.ts_coastal,1,1,1,10) - repmat(hadsst3.ts_coastal,1,1,1,1000);
    rnd_pdo = repmat(hadsst3_en.pdo(1:165,:)',10,1) - repmat(hadsst3.pdo(1:165),1000,1);

    Save_trd = Save_trd + repmat(GC_trd,1,1,1000) + rnd_trd;
    Save_TS  = Save_TS  + repmat(GC_TS, 1,1,1,1000) + rnd_TS(:,1:165,:,:);
    Save_TS_coastal  = Save_TS_coastal  + repmat(GC_TS_coastal, 1,1,1,1000) + rnd_TS_coastal(:,1:165,:,:);
    Save_pdo = Save_pdo + repmat(GC_pdo,1000,1) + rnd_pdo;
    Save_pdo_int = Save_pdo_int + repmat(GC_pdo',1,2,1000) + ...
                   repmat(reshape(rnd_pdo',165,1,1000),1,2,1);

    file_save = [dir_load,'SUM_corr_rnd_HM_SST_Bucket_deck_level_1_GC',...
                          '_do_rmdup_',num2str(EP.do_rmdup),...
                          '_correct_kobe_',num2str(EP.do_add_JP),...
                          '_connect_kobe_',num2str(EP.connect_kobe),...
                          '_yr_start_',num2str(EP.yr_start),'.mat'];
    save(file_save,'Save_trd','Save_TS','Save_TS_coastal','Save_pdo','Save_pdo_int','-v7.3')
end
