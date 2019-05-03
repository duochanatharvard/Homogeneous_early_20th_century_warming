HM_load_package;

% *************************************************************************
% Download and unzip file
% *************************************************************************
tic;
load('chan_et_al_2019_directories.mat','dir_data')
dir_now = pwd;
cd(dir_data) 
disp(['downloading data ...'])
url= ['https://dataverse.harvard.edu/api/access/datafile/3424709'];
filename = 'Check_points.tar.gz';
websave(filename,url);
!tar -zxvf Check_points.tar.gz
cd(dir_now)
disp(['Downloading data takes ',num2str(toc,'%6.0f'),' seconds'])

% *************************************************************************
% Move check points
%% *************************************************************************
dir_from = [dir_data,'Check_points/'];        % TODO 
                                             % change to name of untarred folder

dir_to = [dir_data,'ICOADSb/HM_SST_Bucket/Step_05_corr_idv/'];
file = ['corr_idv_HM_SST_Bucket_deck_level_1_en_0_do',...
    '_rmdup_0_correct_kobe_0_connect_kobe_1_yr_start_1850.mat'];
if exist([dir_to,file], 'file') == 2,
    disp('File ''corr_idv_HM_SST_Bucket*.mat'' exists.  Skip ...')
else
    try
        movefile([dir_from,file],[dir_to,file]);
        disp(['Moving ''corr_idv_HM_SST_Bucket*.mat''...'])
    catch
        disp(['Error in moving ''corr_idv_HM_SST_Bucket*.mat'''])
    end
end
disp(' ')

dir_to = [dir_data,'ICOADSb/HM_SST_Bucket/Step_04_run/'];
file = ['LME_HM_SST_Bucket_yr_start_1850_deck_level_1_cor_err_',...
    'rmdup_0_rmsml_0_fewer_first_0_correct_kobe_0_connect_kobe_1.mat'];
if exist([dir_to,file], 'file') == 2,
    disp('File ''LME_HM_SST_Bucket*.mat'' exists.  Skip ...')
else
    try
        movefile([dir_from,file],[dir_to,file]);
        disp(['Moving ''LME_HM_SST_Bucket*.mat''...'])
    catch
        disp(['Error in moving ''LME_HM_SST_Bucket*.mat'''])
    end
end
disp(' ')

dir_to = [dir_data,'ICOADSb/HM_SST_Bucket/'];
file = ['SUM_corr_idv_HM_SST_Bucket_deck_level_1_do_',...
    'rmdup_0_correct_kobe_0_connect_kobe_1_yr_start_1850.mat'];
if exist([dir_to,file], 'file') == 2,
    disp('File ''SUM_corr_idv*.mat'' exists.  Skip ...')
else
    try
        movefile([dir_from,file],[dir_to,file]);
        disp(['Moving ''SUM_corr_idv*.mat''...'])
    catch
        disp(['Error in moving ''SUM_corr_idv*.mat'''])
    end
end
disp(' ')

dir_to = [dir_data,'ICOADSb/HM_SST_Bucket/'];
file = ['SUM_corr_rnd_HM_SST_Bucket_deck_level_1_do_',...
    'rmdup_0_correct_kobe_0_connect_kobe_1_yr_start_1850.mat'];
if exist([dir_to,file], 'file') == 2,
    disp('File ''SUM_corr_rnd*.mat'' exists.  Skip ...')
else
    try
        movefile([dir_from,file],[dir_to,file]);
        disp(['Moving ''SUM_corr_rnd*.mat''...'])
    catch
        disp(['Error in moving ''SUM_corr_rnd*.mat'''])
    end
end
disp(' ')

dir_to = [dir_data,'ICOADSb/HM_SST_Bucket/Step_03_SUM_Pairs/'];
file = ['SUM_HM_SST_Bucket_Screen_Pairs_c_once_1850_2014',...
    '_NpD_1_rmdup_0_rmsml_0_fewer_first_0.mat'];
if exist([dir_to,file], 'file') == 2,
    disp('File ''SUM_HM_SST_Bucket_Screen_Pairs*.mat'' exists.  Skip ...')
else
    try
        movefile([dir_from,file],[dir_to,file]);
        disp(['Moving ''SUM_HM_SST_Bucket_Screen_Pairs*.mat''...'])
    catch
        disp(['Error in moving ''SUM_HM_SST_Bucket_Screen_Pairs*.mat'''])
    end
end
disp(' ')
disp('------------------------------------------------')
disp(' ')