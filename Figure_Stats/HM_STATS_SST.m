% This script generate statistics with respect to ICOADSa and ICOADSb
% This script also generate Table 1

HM_load_package;

% ********************************************************************
% The color scheme sensitive to parameters
% This script gaurantees the reproduction of colormap in the main text
% 
% Uncomment the following lines 
% if you are not using Quick_start.m to access this script
% ********************************************************************

% varname = 'SST';
% method = 'Bucket';
% do_NpD = 1;
% app_exp = 'cor_err';
% EP.do_rmdup = 0;
% EP.do_rmsml = 0;
% EP.sens_id  = 0;
% EP.do_fewer_first = 0;
% EP.connect_kobe   = 1;
% EP.do_add_JP = 0;
% EP.yr_start = 1850;


P = HM_lme_exp_para(varname,method);
alpha = 0.0455;
scale = 3.4;
yr_list = 1908:1941;  % for computing interannual correlations

% ***********************************
% Input / Output                   **
% ***********************************
dir_home = HM_OI('home');

app = ['HM_',varname,'_',method];
if app(end)=='_', app(end)=[]; end
app(end+1) = '/';

% ********************************************************************
% Read trd files in correction and randomized correction            **
% ********************************************************************
dir_load = [dir_home,app];
file_idv = [dir_load,'SUM_corr_idv_',app(1:end-1),'_deck_level_',...
                               num2str(do_NpD),'_GC',...
                               '_do_rmdup_',num2str(EP.do_rmdup),...
                               '_correct_kobe_',num2str(EP.do_add_JP),...
                               '_connect_kobe_',num2str(EP.connect_kobe),...
                               '_yr_start_',num2str(EP.yr_start),'.mat'];
file_rnd = [dir_load,'SUM_corr_rnd_',app(1:end-1),'_deck_level_',...
                               num2str(do_NpD),'_GC',...
                               '_do_rmdup_',num2str(EP.do_rmdup),...
                               '_correct_kobe_',num2str(EP.do_add_JP),...
                               '_connect_kobe_',num2str(EP.connect_kobe),...
                               '_yr_start_',num2str(EP.yr_start),'.mat'];

load(file_idv,'Main_trd','Main_TS','Main_TS_coastal')
load(file_rnd,'Save_trd','Save_TS','Save_TS_coastal')

% **********************************************
% Read the trend of other SST products        **
% **********************************************
dir_mis  = [dir_home,HM_OI('mis')];
file_mis = [dir_mis,'1908_1941_Trd_TS_and_pdo_from_all_existing_datasets_20190424.mat'];
if strcmp(varname,'SST')
    other_ds = load(file_mis,'cobesst2','ersst5','hadsst3','hadsst3_en','hadisst2','sampling');
end

file_load = [dir_mis,'CRUTEM.4.6.0.0.anomalies.nc'];
CRUT = ncread(file_load,'temperature_anomaly');
CRUT = reshape(CRUT(:,:,1:1980),72,36,12,165);
CRUT = CRUT([37:72, 1:36],:,:,:);
MASK = HM_function_mask_coastal;
clear('TS_CRUTEM4')
for ct= 1:max(MASK(:))
    TS_CRUTEM4(:,:,ct) = HM_function_mask_average(CRUT,[-87.5:5:87.5],MASK==ct);
end
TS_CRUTEM4_ann = squeeze(nanmean(TS_CRUTEM4(:,[yr_list]-1849,:),1));

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

%% ********************************************************************
% Generate Masks to compute trend for regions in Table 1            **
% ********************************************************************
clear('mask_out','mask_out_coastal')

% masks for ocean basins
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

% masks for coastal areas
MASK = HM_function_mask_coastal;
for i = 1:2 mask_out_coastal(:,:,i) = MASK == i; end

% ********************************************************************
% Compute the spatial correlation and trends in Table 1
% *********************************************************************
Tab_trd = [];
trd_corr = Main_trd(:,:,2) - Main_trd(:,:,1);
for ct = 1:6
    switch ct,
        case 1,
            data_temp.trd = Main_trd(:,:,1);
            data_temp.ts_coastal = Main_TS_coastal(:,:,:,1);
            temp = squeeze(nanmean(data_temp.ts_coastal,1));
            temp = temp([yr_list] - 1849,:);
        case 2,
            data_temp.trd = Main_trd(:,:,2);   
            data_temp.ts_coastal = Main_TS_coastal(:,:,:,2);
            temp = squeeze(nanmean(data_temp.ts_coastal,1));
            temp = temp([yr_list] - 1849,:); 
        case 3,
            data_temp = other_ds.ersst5;
            temp = squeeze(nanmean(data_temp.ts_coastal,1));
            temp = temp([yr_list] - 1853,:);
        case 4,
            data_temp = other_ds.cobesst2;
            temp = squeeze(nanmean(data_temp.ts_coastal,1));
            temp = temp([yr_list] - 1849,:);
        case 5,
            data_temp = other_ds.hadisst2;
            temp = squeeze(nanmean(nanmean(data_temp.ts_coastal,4),1));
            temp = temp([yr_list] - 1849,:);
        case 6,
            data_temp = other_ds.hadsst3;
            temp = squeeze(nanmean(data_temp.ts_coastal,1));
            temp = temp([yr_list] - 1849,:);
    end

    % *********************************************
    % Compute the correlation 
    % *********************************************
    tem = data_temp.trd;
    tem = nanmean(tem,3);
    Tab_corr(ct) = CDC_corr(trd_corr(:),tem(:));

    % *********************************************
    % Compute the trends for basins     
    % *********************************************
    for reg = 1:size(mask_out,3)
        Tab_trd(reg,ct) = HM_function_mask_average(nanmean(data_temp.trd,3) * scale, ...
            [-87.5:5:87.5],mask_out(:,:,reg));
    end

    % *********************************************
    % Compute the trends for costal regions  
    % *********************************************
    for reg = 1:size(mask_out_coastal,3)
        Tab_trd_coastal(reg,ct) = HM_function_mask_average(nanmean(data_temp.trd,3) * scale, ...
            [-87.5:5:87.5],mask_out_coastal(:,:,reg));
    end

    % *********************************************
    % Compute the land correlation
    % *********************************************
    for reg = 1:size(mask_out_coastal,3)
        Tab_r_coastal(reg,ct) = CDC_corr(TS_CRUTEM4_ann(:,reg),temp(:,reg),1);
    end
end


%% ********************************************************************
% Compute the uncertainty associated with trends                    **
% ********************************************************************
clear('Tab_trd_icoada','Tab_trd_icoadb','Tab_trd_had','Tab_trd_hadi')
clear('Tab_trd_icoada_coastal','Tab_trd_icoadb_coastal',...
      'Tab_trd_had_coastal','Tab_trd_hadi_coastal')
for i = 1:size(mask_out,3)
    
    % ICOADSa
    temp  = repmat(Main_trd(:,:,1),1,1,1000) + other_ds.sampling.trd + data_gc_rnd;
    Tab_trd_icoada(:,i) = HM_function_mask_average(temp * scale, [-87.5:5:87.5],mask_out(:,:,i));
    if i<= size(mask_out_coastal,3),
        Tab_trd_icoada_coastal(:,i) = HM_function_mask_average(temp * scale, [-87.5:5:87.5],mask_out_coastal(:,:,i));
    end
    
    % ICOADSb
    temp  = Save_trd + other_ds.sampling.trd;
    Tab_trd_icoadb(:,i) = HM_function_mask_average(temp * scale, [-87.5:5:87.5],mask_out(:,:,i));
    if i<= size(mask_out_coastal,3),
        Tab_trd_icoadb_coastal(:,i) = HM_function_mask_average(temp * scale, [-87.5:5:87.5],mask_out_coastal(:,:,i));
    end

    % HadSST3
    temp = other_ds.sampling.trd(:,:,1:1:1000) + repmat(other_ds.hadsst3_en.trd,1,1,10);
    Tab_trd_had(:,i) = HM_function_mask_average(temp * scale, [-87.5:5:87.5],mask_out(:,:,i));
    if i<= size(mask_out_coastal,3),
        Tab_trd_had_coastal(:,i) = HM_function_mask_average(temp * scale, [-87.5:5:87.5],mask_out_coastal(:,:,i));
    end
    
    % HadISST2
    temp = other_ds.hadisst2.trd;
    Tab_trd_hadi(:,i) = HM_function_mask_average(temp * scale, [-87.5:5:87.5],mask_out(:,:,i));
    if i<= size(mask_out_coastal,3),
        Tab_trd_hadi_coastal(:,i) = HM_function_mask_average(temp * scale, [-87.5:5:87.5],mask_out_coastal(:,:,i));
    end
end

clear('Tab_un')
Tab_un = nan(size(mask_out,3),6);
Tab_un(:,1) = CDC_std(Tab_trd_icoada,1);
Tab_un(:,2) = CDC_std(Tab_trd_icoadb,1);
Tab_un(:,5) = CDC_std(Tab_trd_hadi,1);
Tab_un(:,6) = CDC_std(Tab_trd_had,1);

clear('Tab_un_coastal')
Tab_un_coastal = nan(size(mask_out_coastal,3),6);
Tab_un_coastal(:,1) = CDC_std(Tab_trd_icoada_coastal,1);
Tab_un_coastal(:,2) = CDC_std(Tab_trd_icoadb_coastal,1);
Tab_un_coastal(:,5) = CDC_std(Tab_trd_hadi_coastal,1);
Tab_un_coastal(:,6) = CDC_std(Tab_trd_had_coastal,1);

%% *******************************************************************
% Display results
% ********************************************************************
titles = {'ICOADSa','ICOADSb','ERSST5','COBESST2','HadISST2','HadSST3'};

disp(['----------------------------------------------------------']);
disp(' ');
disp(['Table 1 in Chan et al., 2019:']);
disp(['statistics (the 1st row) and 2 s.d. uncertainty (the 2nd row, if any):']);
disp(' ');

disp('BASIN STATISTICS');
disp(' ');

disp(['Global 1908-1941 SST trends (C/34 years)']);
disp(sprintf('%-10s',titles{:}))
disp([num2str(Tab_trd(1,:),'%-10.2f')]);
disp([num2str(Tab_un(1,:)*2,'%-10.2f')]);
disp(' ');

disp(['North Atlantic 1908-1941 SST trends (C/34 years)']);
disp(sprintf('%-10s',titles{:}))
disp([num2str(Tab_trd(2,:),'%-10.2f')]);
disp([num2str(Tab_un(2,:)*2,'%-10.2f')]);
disp(' ');

disp(['North Pacific 1908-1941 SST trends (C/34 years)']);
disp(sprintf('%-10s',titles{:}))
disp([num2str(Tab_trd(3,:),'%-10.2f')]);
disp([num2str(Tab_un(3,:)*2,'%-10.2f')]);
disp(' ');

disp(['Northwest Pacific 1908-1941 SST trends (C/34 years)']);
disp(sprintf('%-10s',titles{:}))
disp([num2str(Tab_trd(4,:),'%-10.2f')]);
disp([num2str(Tab_un(4,:)*2,'%-10.2f')]);
disp(' ');

disp(['Northeast Pacific 1908-1941 SST trends (C/34 years)']);
disp(sprintf('%-10s',titles{:}))
disp([num2str(Tab_trd(5,:),'%-10.2f')]);
disp([num2str(Tab_un(5,:)*2,'%-10.2f')]);
disp(' ');

disp('COASTAL STATISTICS');
disp(' ');

disp(['East Asia 1908-1941 Costal SST trends (C/34 years)']);
disp(sprintf('%-10s',titles{:}))
disp([num2str(Tab_trd_coastal(1,:),'%-10.2f')]);
disp([num2str(Tab_un_coastal(1,:)*2,'%-10.2f')]);
disp(' ');

disp(['Eastern U.S. 1908-1941 Costal SST trends (C/34 years)']);
disp(sprintf('%-10s',titles{:}))
disp([num2str(Tab_trd_coastal(2,:),'%-10.2f')]);
disp([num2str(Tab_un_coastal(2,:)*2,'%-10.2f')]);
disp(' ');

disp(['1908-1941 interannual correlation between SST an AT over coastal East Asia']);
disp(sprintf('%-10s',titles{:}))
disp([num2str(Tab_r_coastal(1,:),'%-10.2f')]);
disp(' ');

disp(['1908-1941 interannual correlation over the coastal Eastern U.S.']);
disp(sprintf('%-10s',titles{:}))
disp([num2str(Tab_r_coastal(2,:),'%-10.2f')]);
disp(' ');

disp('OTHER STATISTICS');
disp(' ');

disp(['Spatical correlation between trends and groupwise correction']);
disp(sprintf('%-10s',titles{:}))
disp([num2str(Tab_corr(1,:),'%-10.2f')]);
disp(' ');

disp(['Percentage of grids with significant 1908-1941 trends'])
disp(['       ICOADSa                   ICOADSb       '])
disp(['--------------------      ---------------------'])
disp(['Positive   Negative        Positive   Negative'])
disp(num2str(Stats(2:5)./Stats(1)*100,'%-14.0f'))

disp(' ');
disp(' ');
disp(' ');
disp(' ');