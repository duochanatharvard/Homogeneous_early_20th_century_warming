% This script generate statistics with respect to ICOADSa and ICOADSb
% This script also generate Table 1

clear;

% *****************
% Set Parameters **
% *****************
varname = 'SST';
method = 'Bucket';
do_NpD = 1;
env = 0;
app_exp = 'cor_err';
EP.do_rmdup = 0;
EP.do_rmsml = 0;
EP.sens_id  = 0;
EP.do_fewer_first = 0;
EP.connect_kobe   = 1;
EP.do_add_JP = 0;
EP.yr_start = 1850;
P = HM_lme_exp_para(varname,method);
alpha = 0.0455;
scale = 3.4;
app_version = '';

% ***********************************
% Input / Output                   **
% ***********************************
if ~exist('env','var'),
    env = 1;                             % 1 means on odyssey
end
dir_home = HM_OI('home',env);

app = ['HM_',varname,'_',method];
if app(end)=='_', app(end)=[]; end
app(end+1) = '/';

%% ********************************************************************
% Read trd files in correction and randomized correction            **
% ********************************************************************
dir_load = [dir_home,app];
file_idv = [dir_load,'SUM_corr_idv_',app(1:end-1),'_deck_level_',...
                               num2str(do_NpD),app_version,'_GC',...
                               '_do_rmdup_',num2str(EP.do_rmdup),...
                               '_correct_kobe_',num2str(EP.do_add_JP),...
                               '_connect_kobe_',num2str(EP.connect_kobe),...
                               '_yr_start_',num2str(EP.yr_start),'.mat'];
file_rnd = [dir_load,'SUM_corr_rnd_',app(1:end-1),'_deck_level_',...
                               num2str(do_NpD),app_version,'_GC',...
                               '_do_rmdup_',num2str(EP.do_rmdup),...
                               '_correct_kobe_',num2str(EP.do_add_JP),...
                               '_connect_kobe_',num2str(EP.connect_kobe),...
                               '_yr_start_',num2str(EP.yr_start),'.mat'];

load(file_idv,'Main_trd','Main_TS','Main_TS_coastal')
load(file_rnd,'Save_trd','Save_TS','Save_TS_coastal')

% **********************************************
% Read the trend of other SST products        **
% **********************************************
dir_mis  = [dir_home,HM_OI('mis',env)];
file_mis = [dir_mis,'1908_1941_Trd_TS_and_pdo_from_all_existing_datasets_20180914.mat'];
if strcmp(varname,'SST')
    other_ds = load(file_mis,'cobesst2','ersst5','hadsst3','hadsst3_en','hadisst2','sampling');
end

% ********************************************************************
% Do significance test and do stats for the significance            **
% ********************************************************************
data_gc_rnd = repmat(other_ds.hadsst3_en.trd,1,1,10) - repmat(other_ds.hadsst3.trd,1,1,1000);
data_in = repmat(Main_trd(:,:,1),1,1,size(other_ds.sampling.trd,3)) + other_ds.sampling.trd + data_gc_rnd;
sig_raw   = HM_function_sig_member(data_in,Main_trd(:,:,1),alpha);

data_in = Save_trd + other_ds.sampling.trd;   % ICOADSb statistics already have
                                              % uncertainty estimates of global
                                              % corrections included ...
sig_cored = HM_function_sig_member(data_in,Main_trd(:,:,2),alpha);

l = ~isnan(sig_raw);
sig_raw(~l) = nan;
sig_had(~l) = nan;
Stats = [nnz(l) nnz(sig_raw>0) nnz(sig_raw<0) nnz(sig_cored>0) nnz(sig_cored<0)];
num2str(Stats./Stats(1)*100,'%7.1f')

%% ********************************************************************
% Generate Masks to compute trend for regions in Table 1            **
% ********************************************************************
if 1,    % compute uncertainty for ocean basins
    MASK = HM_function_mask_JP_NA;
    mask_out = HM_function_mask_trd;
    mask_out(:,:,2) = MASK == 2;
    mask_out(:,:,3) = MASK == 1;
    mask_out(:,:,4) = MASK == 1;
    mask_out(:,[1:23 28:end],4) = 0;
    mask_out([1:24 37:end],:,4) = 0;
    mask_out(:,:,5) = MASK == 1;
    mask_out(:,[1:22 30:end],5) = 0;
    mask_out([1:40 49:end],:,5) = 0;
else     % compute uncertainty for coastal areas
    MASK = HM_function_mask_coastal;
    for i = 1:2 mask_out(:,:,i) = MASK == i; end
end

%% ********************************************************************
% Compute the spatial correlation and trends in Table 1
% *********************************************************************
Tab_trd = [];
trd_corr = Main_trd(:,:,2) - Main_trd(:,:,1);
for ct = 1:6
    switch ct,
    case 1,
        data_temp.trd = Main_trd(:,:,1);    % with GC
        data_temp.ts  = Main_TS(:,:,:,1);   % with GC
        temp = squeeze(nanmean(data_temp.ts,1));
        temp = temp([1908:1941] - 1849,:);
    case 2,
        data_temp.trd = Main_trd(:,:,2);    % with GC
        data_temp.ts  = Main_TS(:,:,:,2);   % with GC
        temp = squeeze(nanmean(data_temp.ts,1));
        temp = temp([1908:1941] - 1849,:);
    case 3,
        data_temp = other_ds.ersst5;
        temp = squeeze(nanmean(data_temp.ts,1));
        temp = temp([1908:1941] - 1853,:);
    case 4,
        data_temp = other_ds.cobesst2;
        temp = squeeze(nanmean(data_temp.ts,1));
        temp = temp([1908:1941] - 1849,:);
    case 5,
        data_temp = other_ds.hadisst2;
        temp = squeeze(nanmean(data_temp.ts,1));
        temp = temp([1908:1941] - 1899,:);
    case 6,
        data_temp = other_ds.hadsst3;
        temp = squeeze(nanmean(data_temp.ts,1));
        temp = temp([1908:1941] - 1849,:);
    end

    % -------------------------
    % Compute the correlation |
    % -------------------------
    Tab_corr(ct) = CDC_corr(trd_corr(:),data_temp.trd(:));

    % -------------------------
    % Compute the trends      |
    % -------------------------
    for reg = 1:size(mask_out,3)
        Tab_trd(reg,ct) = HM_function_mask_average(data_temp.trd * scale, ...
                                              [-87.5:5:87.5],mask_out(:,:,reg));
    end
end

%% ********************************************************************
% Compute the uncertainty associated with trends                    **
% ********************************************************************
clear('Tab_trd_icoada','Tab_trd_icoadb','Tab_trd_had')
for i = 1:size(mask_out,3)
    temp  = repmat(Main_trd(:,:,1),1,1,1000) + other_ds.sampling.trd + data_gc_rnd;
    Tab_trd_icoada(:,i) = HM_function_mask_average(temp * scale, [-87.5:5:87.5],mask_out(:,:,i));

    temp  = Save_trd + other_ds.sampling.trd;
    Tab_trd_icoadb(:,i) = HM_function_mask_average(temp * scale, [-87.5:5:87.5],mask_out(:,:,i));

    temp = other_ds.sampling.trd(:,:,1:1:1000) + repmat(other_ds.hadsst3_en.trd,1,1,10);
    Tab_trd_had(:,i) = HM_function_mask_average(temp * scale, [-87.5:5:87.5],mask_out(:,:,i));
end

clear('Tab_un')
Tab_un(:,1) = CDC_std(Tab_trd_icoada,1);
Tab_un(:,2) = CDC_std(Tab_trd_icoadb,1);
Tab_un(:,3) = CDC_std(Tab_trd_had,1);
num2str(Tab_un(:,[1 2 3])*2,'%7.2f')

%% *******************************************************************
% Uncertainty of correlations
% ********************************************************************
Tab_corr_rnd = [];
for ct = 1:1000
    trd_corr = Save_trd(:,:,ct) - Main_trd(:,:,1);
    data_temp.trd = Main_trd(:,:,1);                           % with GC
    Tab_corr_rnd(ct) = CDC_corr(trd_corr(:),data_temp.trd(:));
end
disp('Spatial Correlation:')
num2str(Tab_corr,'%6.2f')
CDC_std(Tab_corr_rnd) * 2

%% ********************************************************************
% CMIP5 models                                                      **
% ********************************************************************
dir_mis  = [dir_home,HM_OI('mis',env)];
file_mis = [dir_mis,'1908_1941_CMIP5_trends.mat'];
load(file_mis)

% mask_out = HM_function_mask_regional_trend_table;
for reg = 1:5
    Tab_trd_cmip(reg,:) = HM_function_mask_average(CMIP5.trd * scale, ...
                                          [-87.5:5:87.5],mask_out(:,:,reg));
end
