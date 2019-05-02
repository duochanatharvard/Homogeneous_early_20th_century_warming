HM_load_package;
clear; clc; close all;

tic;
varname = 'SST';
method  = 'Bucket';

% *************************************************************************
% Below are parameters used to reproduce results reported in the main text
% *************************************************************************
do_NpD = 1;                     % Use nation-deck groups
app_exp = 'cor_err';            % Model as in Chan and Huybers (2019)
EP.do_rmdup = 0;                % Do not remove DUPS != 0
EP.do_rmsml = 0;                % Do not remove small groups
EP.sens_id  = 0;                % Use 5-year and 17-region binning
EP.do_fewer_first = 0;          % Priority in pair screening: distance
EP.connect_kobe   = 1;          % Combine Kobe collection decks
EP.do_add_JP = 0;               % Correct JPKB truancation before LME
EP.yr_start = 1850;             % Staring year of the first 5-year bin
EP.do_focus = 1;                % Figure 1 focus on 1908-1941

% *************************************************************************
% Download and unzip file
% *************************************************************************
load('chan_et_al_2019_directories.mat','dir_data')
dir_now = pwd;
cd(dir_data) 
!wget https://dataverse.harvard.edu/api/access/datafile/3424404
!tar -zxvf Key_Results.tar.gz
cd(dir_now)

% *************************************************************************
% Move Key Results files
% *************************************************************************
dir_from = [dir_data,'Key_Results/'];        % TODO 
                                             % change to name of untarred folder

dir_to = [dir_data,'ICOADSb/HM_SST_Bucket/'];
file = 'ICOADS_a_b.mat';
if exist([dir_to,file], 'file') == 2,
    disp('File ''ICOADS_a_b.mat'' exists.  Skip ...')
else
    try
        movefile([dir_from,file],[dir_to,file]);
        disp(['Moving ''ICOADS_a_b.mat''...'])
    catch
        disp(['Error in moving ''ICOADS_a_b.mat'''])
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
file = ['SUM_corr_idv_HM_SST_Bucket_deck_level_1_GC_do_',...
    'rmdup_0_correct_kobe_0_connect_kobe_1_yr_start_1850.mat'];
if exist([dir_to,file], 'file') == 2,
    disp('File ''SUM_corr_idv_GC*.mat'' exists.  Skip ...')
else
    try
        movefile([dir_from,file],[dir_to,file]);
        disp(['Moving ''SUM_corr_idv_GC*.mat''...'])
    catch
        disp(['Error in moving ''SUM_corr_idv_GC*.mat'''])
    end
end
disp(' ')

dir_to = [dir_data,'ICOADSb/HM_SST_Bucket/'];
file = ['SUM_corr_rnd_HM_SST_Bucket_deck_level_1_GC_do_',...
    'rmdup_0_correct_kobe_0_connect_kobe_1_yr_start_1850.mat'];
if exist([dir_to,file], 'file') == 2,
    disp('File ''SUM_corr_rnd_GC*.mat'' exists.  Skip ...')
else
    try
        movefile([dir_from,file],[dir_to,file]);
        disp(['Moving ''SUM_corr_rnd_GC*.mat''...'])
    catch
        disp(['Error in moving ''SUM_corr_rnd_GC*.mat'''])
    end
end
disp(' ')

dir_to = [dir_data,'ICOADSb/HM_SST_Bucket/'];
file = ['Stats_HM_SST_Bucket_deck_level_1.mat'];
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

dir_to = [dir_data,'ICOADSb/Miscellaneous/'];
file = ['CRUTEM.4.6.0.0.anomalies.nc'];
if exist([dir_to,file], 'file') == 2,
    disp('File ''CRUTEM.4.6.0.0.anomalies.nc'' exists.  Skip ...')
else
    try
        movefile([dir_from,file],[dir_to,file]);
        disp(['Moving ''CRUTEM.4.6.0.0.anomalies.nc''...'])
    catch
        disp(['Error in moving ''CRUTEM.4.6.0.0.anomalies.nc'''])
    end
end
disp(' ')

dir_to = [dir_data,'ICOADSb/Miscellaneous/'];
file = ['1908_1941_Trd_TS_and_pdo_from_all_existing_datasets_20190424.mat'];
if exist([dir_to,file], 'file') == 2,
    disp('File ''Trd_TS_and_pdo_from_all_existing_datasets.mat'' exists.  Skip ...')
else
    try
        movefile([dir_from,file],[dir_to,file]);
        disp(['Moving ''Trd_TS_and_pdo_from_all_existing_datasets.mat''...'])
    catch
        disp(['Error in moving ''Trd_TS_and_pdo_from_all_existing_datasets.mat'''])
    end
end
disp(' ')
disp('------------------------------------------------')
disp(' ')

% *************************************************************************
% Generate Table 1
% *************************************************************************
clearvars -except varname method do_NpD app_exp EP
HM_STATS_SST;

% *************************************************************************
% Generate Offsets for individual groups reported in the main text
% *************************************************************************
clearvars -except varname method do_NpD app_exp EP
HM_STATS_LME;

% *************************************************************************
% Generate Figure 1
% *************************************************************************
clearvars -except varname method do_NpD app_exp EP
disp(['Plotting figure 1 ...'])
disp([' '])
HM_Fig_1;

% *************************************************************************
% Generate Figure 2
% *************************************************************************
clearvars -except varname method do_NpD app_exp EP
disp(['Plotting figure 2 ...'])
disp([' '])
HM_Fig_2;

% *************************************************************************
% Generate Figure 3
% *************************************************************************
clearvars -except varname method do_NpD app_exp EP
disp(['Plotting figure 3 ...'])
disp([' '])
HM_Fig_3;

% *************************************************************************
% Generate Figure 4
% *************************************************************************
clearvars -except varname method do_NpD app_exp EP
disp(['Plotting figure 4 ...'])
disp([' '])
HM_Fig_4;

disp(['Quick reproduction takes ',num2str(toc,'%6.0f'),' seconds'])