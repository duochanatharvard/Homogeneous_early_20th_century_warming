%% ************************************************************************
% The following scripts are used to generate ensemble members from 1850-1941
% *************************************************************************
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
% Load HadSST common bucket bias corrections
% ********************************************************
start_ratio = 35;
mass_small = 0.65;
mass_large = 1.7;
app = ['start_ratio_',num2str(start_ratio),'_mass_small_',num2str(mass_small),...
    '_mass_large_',num2str(mass_large),'_start_ratio_',num2str(start_ratio)];
dir_GC = HM_OI('Global_correction',env);
file_GC = [dir_GC,'Global_Bucket_Correction_',app,'.mat'];
load(file_GC,'Corr_save')     % this is bias, take minus sign for correction

% ********************************************************
% Load HadSST3 global correction
% ********************************************************
dir_load = HM_OI('Mis',env);
load([dir_load,'All_earlier_SST_restimates_regridded_to_5x5_grids.mat'],'HadSST3')
had_ref = reshape(HadSST3.sst(:,:,1:1980),72,36,12,165);


% ********************************************************
% Generate ICOADSb random ensembles
% ********************************************************
for en = 1:1000
    
    clear('WM')
    dir_load = [HM_OI('home',env), HM_OI('corr_rnd',env,[],'SST','Bucket')];
    file_load = [dir_load,'corr_rnd_HM_SST_Bucket_deck_level_',...
              num2str(do_NpD),'_en_',num2str(en),...
              '_do_rmdup_',num2str(EP.do_rmdup),...
              '_correct_kobe_',num2str(EP.do_add_JP),...
              '_connect_kobe_',num2str(EP.connect_kobe),...
                  '_yr_start_',num2str(EP.yr_start),'.mat'];
    load(file_load,'WM');

    had_cor = reshape(HadSST3.sst_en(:,:,1:1980,rem(en-0.5,100)+0.5),72,36,12,165);
    had_un = had_cor - had_ref;
    had_un(isnan(had_un)) = 0;
    clear('ICOADSb')
    ICOADSb = WM - Corr_save + had_un;
    ICOADSb = ICOADSb(:,:,:,[1850:1941]-1849);

    % ********************************************************
    % Save data
    % ********************************************************
    dir_save = [HM_OI('home',env),'HM_SST_Bucket/ICOADSb_ensemble/'];
    file_save = [dir_save,'ICOADSb_ensemble_',num2str(en),'.mat'];
    save(file_save,'ICOADSb','-v7.3')
    clear('ICOADSb')
end