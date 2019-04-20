% some examples:
% dir_load = [HM_OI('read_raw',env),HM_OI('NMAT_raw')];
% dir_load = [HM_OI('home',env),HM_OI('NMAT_raw')];
% dir_save = [dir_home,app];
% !!! Make sure to set this up before running any script !!!

function [output,app] = HM_OI(input,env,app,varname,method)

    if ~exist('env','var')
        env = 1;    % 1 means on odyssey, default, see below
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
        % home directory of the LME intercomparison analysis
        % we provide options to run this code in different enviromment
        % this is achieved by changing the variable ''env'' in individual
        % scripts
        % env 1 will be the default environment
        if env == 1,
           output = ['/n/home10/dchan/holy_kuang/Test_Hvd_SST/',app];
        elseif env == 2,
           output = ['/Users/zen/Desktop/Hvd_SST/',app];
        else
           output = ['/Volumes/My Passport Pro/SST/Test_Hvd_SST/',app];
        end
        
    elseif strcmp(input,'read_raw')
        % directory to read raw SST dataset
        if env == 1,
            output = '/n/home10/dchan/holy_kuang/ICOADS3/';
        else
            % output = '/Volumes/My Passport Pro/SST/Test_pre_process_ICOADS/';
            output = '/Volumes/My Passport Pro/ICOADS3/';
        end

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

    elseif strcmp(input,'diurnal')
        % directory for files of buoy based diurnal cycles
        output = ['Miscellaneous/'];

    elseif strcmp(input,'mis')
        output = ['Miscellaneous/'];

    elseif strcmp(input,'save_figure_science');
        % directory for output figures
        output = ['/Users/zen/Dropbox/Research/Figures/'];
                                          
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
