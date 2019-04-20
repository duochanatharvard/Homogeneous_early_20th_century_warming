HM_load_package;

varname = 'SST';
method  = 'Bucket';

% *****************
% Set parameters **
% *****************
do_individual = 0;       % Correct for all groups
                         % When do_individual is zero and ensemble member (en) is nonzero,
                         % Random correction is automatically turned on.

 % Following parameters are the same as in Step_03_LME_corr_err_dup.m
 % Make sure that they match
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
if ~exist('env','var'),
    env = 1;                             % 1 means on odyssey
end
dir_home = HM_OI('home',env);

app = ['HM_',varname,'_',method];
if app(end)=='_', app(end)=[]; end
app(end+1) = '/';

dir_save = [dir_home,HM_OI('corr_rnd',env,app)];

% *******************
% Start correction **
% *******************
for ct = 1:1000

    % *************
    % Correction **
    % *************
    en = ct;                      % Number of random correction members
    [WM,ST,NUM] = HM_correct(varname,method,do_NpD,en,do_individual,EP);

    % ************
    % Save Data **
    % ************
    disp('Saving Data ...')
    file_save = [dir_save,'corr_rnd_',app(1:end-1),'_deck_level_',...
              num2str(do_NpD),'_en_',num2str(en),...
              '_do_rmdup_',num2str(EP.do_rmdup),...
              '_correct_kobe_',num2str(EP.do_add_JP),...
              '_connect_kobe_',num2str(EP.connect_kobe),...
              '_yr_start_',num2str(EP.yr_start),'.mat'];
    save(file_save,'WM','ST','NUM');
end
