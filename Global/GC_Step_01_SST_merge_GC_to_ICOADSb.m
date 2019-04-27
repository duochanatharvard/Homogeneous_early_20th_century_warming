HM_load_package;

% *****************
% Set parameters **
% *****************
do_NpD = 1;
EP.do_rmdup = 0;
EP.do_rmsml = 0;
EP.sens_id  = 0;
EP.do_fewer_first = 0;
EP.connect_kobe   = 1;
EP.do_add_JP = 0;
EP.yr_start = 1850;

% *******************
% Input and Output **
% *******************
env = 0;
dir_home = HM_OI('home',env);

% ********************************************************
% Load HvdSST regional correction
% ********************************************************
dir_load = [HM_OI('home',env), HM_OI('corr_idv',env,[],'SST','Bucket')];
file_load = [dir_load,'corr_idv_HM_SST_Bucket_deck_level_',...
          num2str(do_NpD),'_en_',num2str(0),...
          '_do_rmdup_',num2str(EP.do_rmdup),...
          '_correct_kobe_',num2str(EP.do_add_JP),...
          '_connect_kobe_',num2str(EP.connect_kobe),...
              '_yr_start_',num2str(EP.yr_start),'.mat'];
load(file_load,'WM');

% ********************************************************
% Load HadSST global correction
% ********************************************************
start_ratio = 35;
mass_small = 0.65;
mass_large = 1.7;
app = ['start_ratio_',num2str(start_ratio),'_mass_small_',num2str(mass_small),...
    '_mass_large_',num2str(mass_large),'_start_ratio_',num2str(start_ratio)];
dir_GC = HM_OI('Global_correction',env);
file_GC = [dir_GC,'Global_Bucket_Correction_',app,'.mat'];
load(file_GC,'Corr_save')

% ********************************************************
% Prepare for different datasets
% ********************************************************
SST_Raw = squeeze(WM(:,:,1,:,:));
SST_GC  = squeeze(WM(:,:,1,:,:)) - Corr_save;
SST_RC  = squeeze(WM(:,:,2,:,:));
SST_GCRC = squeeze(WM(:,:,2,:,:)) - Corr_save;

% ********************************************************
% Save merged data
% ********************************************************
app = ['start_ratio_',num2str(start_ratio),'_mass_small_',num2str(mass_small),...
    '_mass_large_',num2str(mass_large),'_start_ratio_',num2str(start_ratio)];
dir_save = [HM_OI('home',env),'/HM_SST_Bucket/'];
file_save = [dir_save,'HvdSST_Bucket_only_do_rmdup_',num2str(EP.do_rmdup),...
          '_correct_kobe_',num2str(EP.do_add_JP),...
          '_connect_kobe_',num2str(EP.connect_kobe),...
              '_yr_start_',num2str(EP.yr_start),'.mat'];
save(file_save,'SST_Raw','SST_GC','SST_RC','SST_GCRC','-v7.3')


ICOADSa = SST_GC;
ICOADSb = SST_GCRC;
lon = 2.5:5:357.5;
lat = -87.5:5:90;
yrs = 1850:2014;
file_save = [dir_save,'ICOADS_a_b.mat'];
save('ICOADS_a_b.mat','ICOADSa','ICOADSb','lon','lat','yrs','-v7.3')



