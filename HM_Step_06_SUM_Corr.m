HM_load_package;

varname = 'SST';
method  = 'Bucket';
num_idv = 163;
env = 0;

% *****************
% Set parameters **
% *****************
do_idv = 1;              % For mean correction, when equals to zero, random correction        
P = HM_correct_para;
yr_list = P.yr_list;     % Years used to compute trend
EP.sens_id  = 0;
P = HM_lme_exp_para(varname,method,EP.sens_id);
yr_data = P.yr_list;     % Years used for regional time series

% Following parameters are the same as in Step_03_LME_corr_err_dup.m
% Make sure that they match
do_NpD = 1;
EP.do_rmdup = 0;
EP.do_rmsml = 0;
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

if do_idv == 1;
    dir_load = [dir_home,app,HM_OI('corr_idv',env)];
else
    dir_load = [dir_home,app,HM_OI('corr_rnd',env)];
end

% ********************
% Prepare for masks **
% ********************
MASK = HM_function_mask_JP_NA;

% ******************************
% Post Processing and summing **
% ******************************
for ct = 1:num_idv

    if rem(ct,30) == 0, disp(['Starting the ',num2str(ct),'th member']); end

    if do_idv == 1;
        en = ct - 1;
        file_load = [dir_load,'corr_idv_',app(1:end-1),'_deck_level_',...
                     num2str(do_NpD),'_en_',num2str(en),...
                     '_do_rmdup_',num2str(EP.do_rmdup),...
                     '_correct_kobe_',num2str(EP.do_add_JP),...
                     '_connect_kobe_',num2str(EP.connect_kobe),...
                     '_yr_start_',num2str(EP.yr_start),'.mat'];

    else
        en = ct;
        file_load = [dir_load,'corr_rnd_',app(1:end-1),'_deck_level_',...
                     num2str(do_NpD),'_en_',num2str(en),...
                     '_do_rmdup_',num2str(EP.do_rmdup),...
                     '_correct_kobe_',num2str(EP.do_add_JP),...
                     '_connect_kobe_',num2str(EP.connect_kobe),...
                     '_yr_start_',num2str(EP.yr_start),'.mat'];
    end

    try,
        load(file_load,'WM','NUM');

        % ******************************
        % Post Processing and summing **
        % ******************************
        if en ~= 0,
            clear('SST','NUM','SST_trd','NUM_trd')
            SST = squeeze(WM(:,:,:,:));
            if ~strcmp(method,'ERI'),
                SST_trd = squeeze(WM(:,:,:,yr_list-yr_data(1)+1));
            else
                SST_trd = [];
            end

            [Save_trd(:,:,en),Save_TS(:,:,:,en),Save_pdo(en,:),Save_pdo_int(:,:,en),Save_TS_coastal(:,:,:,en)]...
                                    = HM_function_postprocess_step12(SST,SST_trd,MASK,env);

        else

            for i = 1:2
                clear('SST','NUM','SST_trd','NUM_trd')
                SST = squeeze(WM(:,:,i,:,:));
                if ~strcmp(method,'ERI'),
                    SST_trd = squeeze(WM(:,:,i,:,yr_list-yr_data(1)+1));
                else
                    SST_trd = [];
                end

                [Main_trd(:,:,i),Main_TS(:,:,:,i),Main_pdo(i,:),Main_pdo_int(:,:,i),Main_TS_coastal(:,:,:,i)]...
                                        = HM_function_postprocess_step12(SST,SST_trd,MASK,env);
            end
        end
    catch,
        disp('File does not exist')
    end
end

% **************
% Saving Data **
% **************
if do_idv == 1;
    file_save = [dir_home,app,'SUM_corr_idv_',app(1:end-1),'_deck_level_',...
                 num2str(do_NpD),'_do_rmdup_',num2str(EP.do_rmdup),...
                 '_correct_kobe_',num2str(EP.do_add_JP),...
                 '_connect_kobe_',num2str(EP.connect_kobe),...
                 '_yr_start_',num2str(EP.yr_start),'.mat'];
    save(file_save,'Save_trd','Save_TS','Save_pdo','Save_pdo_int',...
                   'Main_trd','Main_TS','Main_pdo','Main_pdo_int',...
                   'Save_TS_coastal','Main_TS_coastal','-v7.3')
else
    file_save = [dir_home,app,'SUM_corr_rnd_',app(1:end-1),'_deck_level_',...
                 num2str(do_NpD),'_do_rmdup_',num2str(EP.do_rmdup),...
                 '_correct_kobe_',num2str(EP.do_add_JP),...
                 '_connect_kobe_',num2str(EP.connect_kobe),...
                 '_yr_start_',num2str(EP.yr_start),'.mat'];
    save(file_save,'Save_trd','Save_TS','Save_pdo','Save_pdo_int','Save_TS_coastal','-v7.3')
end
