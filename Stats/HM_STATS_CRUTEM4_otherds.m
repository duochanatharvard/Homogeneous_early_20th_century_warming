clear;

% *****************
% Set Parameters **
% *****************
env = 0;
EP.do_rmdup = 0;
EP.do_add_JP = 0;
EP.connect_kobe = 1;
EP.yr_start = 1850;

% **************************************************
% Load data                                       **
% **************************************************
dir_save = [HM_OI('home',env),'/HM_SST_Bucket/'];
file_save = [dir_save,'HvdSST_Bucket_only',...
                       '_do_rmdup_',num2str(EP.do_rmdup),...
                       '_correct_kobe_',num2str(EP.do_add_JP),...
                       '_connect_kobe_',num2str(EP.connect_kobe),...
                       '_yr_start_',num2str(EP.yr_start),'.mat'];

load(file_save,'SST_Raw','SST_GC','SST_RC','SST_GCRC')
N = nanmean(nanmean(SST_GCRC(:,:,:,[1908:1940]-1849),4),3);

dir_load = '/Volumes/My Passport Pro/Hvd_SST/SST_products/';
dir_load = '/Users/zen/Desktop/';
file_load = [dir_load,'CRUTEM.4.6.0.0.anomalies.nc'];
CRUT = ncread(file_load,'temperature_anomaly');
CRUT = reshape(CRUT(:,:,1:1980),72,36,12,165);
CRUT = CRUT([37:72, 1:36],:,:,:);

% trend of individual regions in CRUTEM4, trend of ICOADSa and ICOADSb are computed
% in HM_STATS_SST.m
no_land = 0;
CRUT_trd = HM_function_infill_and_trend(CRUT(:,:,:,[1908:1941]-1849),3,3,0.75,no_land);
MASK = HM_function_mask_coastal;
for i = 1:2 mask_out(:,:,i) = MASK == i; end
for reg = 1:size(mask_out,3)
    Tab_CRUT_trd(reg) = HM_function_mask_average(CRUT_trd * 3.4,[-87.5:5:87.5],mask_out(:,:,reg));
end

MASK = HM_function_mask_coastal;
clear('TS')
for ct= 1:2
    TS(:,:,1,ct) = HM_function_mask_average(CRUT,[-87.5:5:87.5],MASK==ct);
end

%% **************************************************
% Compute for other datasets                       **
% ***************************************************
load('/Volumes/My Passport Pro/Hvd_SST/Miscellaneous/1908_1941_Trd_TS_and_pdo_from_all_existing_datasets_20190424.mat',...
        'cobesst2','ersst5','hadisst2','hadsst3','hadsst3_en','sampling','hadsst3_raw')
MASK = HM_function_mask_coastal;
for i = 1:2 mask_out(:,:,i) = MASK == i; end
for reg = 1:size(mask_out,3)
    Tab_otds_trd(reg,1) = HM_function_mask_average(ersst5.trd * 3.4,[-87.5:5:87.5],mask_out(:,:,reg));
    Tab_otds_trd(reg,2) = HM_function_mask_average(cobesst2.trd * 3.4,[-87.5:5:87.5],mask_out(:,:,reg));
    Tab_otds_trd(reg,3) = HM_function_mask_average(nanmean(hadisst2.trd,3) * 3.4,[-87.5:5:87.5],mask_out(:,:,reg));
    Tab_otds_trd(reg,4) = HM_function_mask_average(hadsst3.trd * 3.4,[-87.5:5:87.5],mask_out(:,:,reg));
    Tab_otds_trd(reg,5) = HM_function_mask_average(hadsst3_raw.trd * 3.4,[-87.5:5:87.5],mask_out(:,:,reg));
end

for reg = 1:size(mask_out,3)
    Tab_otds_trd_en(:,reg) = HM_function_mask_average(hadsst3_en.trd * 3.4,[-87.5:5:87.5],mask_out(:,:,reg));
    Tab_otds_trd_sam(:,reg) = HM_function_mask_average(sampling.trd * 3.4,[-87.5:5:87.5],mask_out(:,:,reg));
end

%% correlation in Table 1
clear('AT','SST')
AT = squeeze(nanmean(TS,1));
SST(5:165,1:2,1) = squeeze(nanmean(ersst5.ts_coastal(:,[1854:2014]-1853,:),1));
SST(1:165,1:2,2) = squeeze(nanmean(cobesst2.ts_coastal(:,[1850:2014]-1849,:),1));
SST(1:158,1:2,3) = squeeze(nanmean(nanmean(hadisst2.ts_coastal(:,[1850:2007]-1849,:,:),1),4));
SST(1:165,1:2,4) = squeeze(nanmean(hadsst3.ts_coastal(:,[1850:2014]-1849,:),1));
SST(1:165,1:2,5) = squeeze(nanmean(hadsst3_raw.ts_coastal(:,[1850:2014]-1849,:),1));

for en = 1:5
    Tab_corr(:,en) =  CDC_corr(AT([1908:1941]-1849,:),SST([1908:1941]-1849,:,en),1);
end