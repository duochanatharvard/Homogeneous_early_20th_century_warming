%% A script that run LME model for intercomparison
% Assuming independent and identically distributed pairs
HM_load_package;

varname = 'SST';
method  = 'Bucket';
pick_limit = 1850;

% *************************************************
% This is the setup for results in the main text
% Sensitivity tests can be performed by tuning these Parameters
% But please do go through the whole set of code
% before making any changes !!!
% *************************************************
do_NpD       = 1;                   % Use nation and deck to group measurements
EP.do_rmdup  = 0;                   % Do not remove measurements whose DUPS!=0
EP.do_rmsml  = 0;                   % Use all groups contributing to more than 5000 pairs
EP.sens_id   = 0;                   % Sensitivity test ID, zero means turned off
                                    % sens_id == 1: remove regional effect
                                    % sens_id == 2: bin by ten years
EP.do_fewer_first = 0;              % Screen pairs with priority in distance
EP.connect_kobe   = 1;              % Combine deck 118, 119, and 762.
EP.do_add_JP = 0;                   % Do not preturb Japanese deck 118 SSTs
yr_start = 1850;                    % Beginning year of the first 5-year increment
do_correct = 1;                     % Use model in sec 5.a in Chan and Huybers, 2019
do_eqwt = 1;                        % Individual pairs have equal weight in aggregation
do_kent = 0;                        % Use homogeneous observational error estimates
do_trim = 0;                        % Do not trim data using 3-sigma std
yr_list  = [pick_limit:2014];

% ***********************
% Set other Parameters **
% ***********************
do_refit = 0;
app_exp = HM_function_set_case(do_correct,do_eqwt,do_kent,do_trim,[]);
if EP.sens_id == 1,
    app_exp  = [app_exp,'_coarse_sp'];
elseif EP.sens_id == 2,
    app_exp  = [app_exp,'_coarse_tim'];
end

% ******
% O/I **
% ******
if ~exist('env','var'),
    env = 1;            % 1 means on odyssey
end

dir_home = HM_OI('home',env);
app = ['HM_',varname,'_',method];
if app(end)=='_', app(end)=[]; end
app(end+1) = '/';
dir_load = [dir_home,app];

% ***********************
% Prepare output files **
% ***********************
read_app       = ['_NpD_',num2str(do_NpD),'_rmdup_',...
                  num2str(EP.do_rmdup),'_rmsml_',num2str(EP.do_rmsml),...
                 '_fewer_first_',num2str(EP.do_fewer_first)];
yr_text        = [];
file_sum_pairs = [dir_load,'Step_03_SUM_Pairs/SUM_',...
                 app(1:end-1),'_Screen_Pairs_c_once_',num2str(yr_list(1)),...
                 '_',num2str(yr_list(end)),read_app,'.mat'];

save_app = ['_rmdup_',...
            num2str(EP.do_rmdup),'_rmsml_',num2str(EP.do_rmsml),...
            '_fewer_first_',num2str(EP.do_fewer_first),...
            '_correct_kobe_',num2str(EP.do_add_JP),...
            '_connect_kobe_',num2str(EP.connect_kobe)];

dir_bin  = [dir_load,HM_OI('LME_run')];
file_bin = [dir_bin,'BINNED_',app(1:end-1),'_yr_start_',num2str(yr_start),...
            '_deck_level_',num2str(do_NpD),'_',app_exp,save_app,'.mat'];
file_lme = [dir_bin,'LME_',app(1:end-1),'_yr_start_',num2str(yr_start),...
            '_deck_level_',num2str(do_NpD),'_',app_exp,save_app,'.mat'];

% ******************************
% Binning and compute the LME **
% ******************************
[BINNED,W_X,Stats] = HM_lme_bin_dup(file_sum_pairs,varname,method,do_NpD,yr_start,do_refit,...
                                    do_correct,do_eqwt,do_kent,do_trim,[],...
                                    env,EP);
save(file_bin,'BINNED','W_X','Stats','-v7.3');

if do_NpD == 0,
    [out,lme] = HM_lme_fit(file_bin,10000,0);
    % Take 10000 samples 
else
    [out,lme] = HM_lme_fit_hierarchy(file_bin,10000,0,1,1);
end
save(file_lme,'out','lme','-v7.3')
