% Output / Input managements

function [output,app] = HM_OI(input,env,app,varname,method)

    if ~exist('env','var')
        env = 1; % enviroment variable is not used
    end

    if isempty(env), env = 1; end

    if ~exist('app','var')
        app = '';
    end

    if exist('varname','var'),
        app = ['HM_',varname,'_',method];
        if app(end)=='_', app(end)=[]; end
        app(end+1) = '/';
    end

    if isempty(app), app = ''; end

    if strcmp(input,'home')
        % home directory for ICOADSb
        load('chan_et_al_2019_directories.mat','dir_home_ICOADSb')
        output = dir_home_ICOADSb; 

    elseif strcmp(input,'read_raw')
        % home directory for ICOADS3
        load('chan_et_al_2019_directories.mat','dir_home_ICOADS3')
        output = dir_home_ICOADS3;

    elseif strcmp(input,'SST_raw')
         % Folder of raw SST dataset
        output = 'ICOADS_QCed/';

    elseif strcmp(input,'NMAT_raw')
        output = 'ICOADS_QCed/';

    elseif strcmp(input,'raw_pairs')
        % directory for initial pairing
        output = [app,'Step_01_Raw_Pairs/'];

    elseif strcmp(input,'screen_pairs')
        % directory for screened pairs
        output = [app,'Step_02_Screen_Pairs/'];

    elseif strcmp(input,'screen_pairs')
        % directory for concatenated pairs
        output = [app,'Step_03_SUM_Pairs/'];

    elseif strcmp(input,'LME_run')
        % directory for LME runs
        output = [app,'Step_04_run/'];

    elseif strcmp(input,'corr_idv')
        % directory for mean correction and correction for individual groups
        output = [app,'Step_05_corr_idv/'];

    elseif strcmp(input,'corr_rnd')
        % directory for random corrections
        output = [app,'Step_06_corr_rnd/'];

    elseif strcmp(input,'diurnal') || strcmp(input,'mis'),
        % directory for files of buoy based diurnal cycles
        output = ['Miscellaneous/'];

    elseif strcmp(input,'Mis')
        output = [HM_OI('home',env),'Miscellaneous/'];

    elseif strcmp(input,'Others')
        % directory of other SST products
        output = [HM_OI('home',env),'SST_products/'];

    elseif strcmp(input,'cmip')
        % directory of other CMIP5 simulations
        output = [HM_OI('home',env),'CMIP5_tos/'];

    elseif strcmp(input,'Global_correction');
        % directory of global bucket corrections
        output = [HM_OI('home',env),'Miscellaneous/'];
    end
end
