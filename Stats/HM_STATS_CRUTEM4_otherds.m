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
load('/Users/zen/Desktop/1908_1941_Trd_TS_and_pdo_from_all_existing_datasets_20180914.mat',...
        'cobesst2','ersst5','hadisst2','hadsst3','hadsst3_en','sampling','hadsst3_raw')
MASK = HM_function_mask_coastal;
for i = 1:2 mask_out(:,:,i) = MASK == i; end
for reg = 1:size(mask_out,3)
    Tab_otds_trd(reg,1) = HM_function_mask_average(ersst5.trd * 3.4,[-87.5:5:87.5],mask_out(:,:,reg));
    Tab_otds_trd(reg,2) = HM_function_mask_average(cobesst2.trd * 3.4,[-87.5:5:87.5],mask_out(:,:,reg));
    Tab_otds_trd(reg,3) = HM_function_mask_average(hadisst2.trd * 3.4,[-87.5:5:87.5],mask_out(:,:,reg));
    Tab_otds_trd(reg,4) = HM_function_mask_average(hadsst3.trd * 3.4,[-87.5:5:87.5],mask_out(:,:,reg));
    Tab_otds_trd(reg,5) = HM_function_mask_average(hadsst3_raw.trd * 3.4,[-87.5:5:87.5],mask_out(:,:,reg));
end

for reg = 1:size(mask_out,3)
    Tab_otds_trd_en(:,reg) = HM_function_mask_average(hadsst3_en.trd * 3.4,[-87.5:5:87.5],mask_out(:,:,reg));
    Tab_otds_trd_sam(:,reg) = HM_function_mask_average(sampling.trd * 3.4,[-87.5:5:87.5],mask_out(:,:,reg));
end

clear('AT','SST')
AT = squeeze(nanmean(TS,1));
SST(5:165,1:2,1) = squeeze(nanmean(ersst5.ts_coastal(:,[1854:2014]-1853,:),1));
SST(1:165,1:2,2) = squeeze(nanmean(cobesst2.ts_coastal(:,[1850:2014]-1849,:),1));
SST(51:161,1:2,3) = squeeze(nanmean(hadisst2.ts_coastal(:,[1900:2010]-1899,:),1));
SST(1:165,1:2,4) = squeeze(nanmean(hadsst3.ts_coastal(:,[1850:2014]-1849,:),1));
SST(1:165,1:2,5) = squeeze(nanmean(hadsst3_raw.ts_coastal(:,[1850:2014]-1849,:),1));


file = '/Volumes/My Passport Pro/ERI_Bucket/Gridded_Raw_SST.mat';
a = load(file);
file = '/Volumes/My Passport Pro/Hvd_SST/HM_SST_Bucket/HvdSST_Bucket_only_do_rmdup_0_correct_kobe_0_connect_kobe_1_yr_start_1850.mat';
aa = load(file);

clf;
subplot(2,2,1); hold on
plot(1908:1941,squeeze(SST([1908:1941]-1849,2,4)),'linewi',2)
plot(1908:1941,squeeze(SST([1908:1941]-1849,2,5)),'linewi',2)
b = HM_function_mask_average(a.SSTM_raw,[-87.5:5:87.5],mask_out(:,:,2));
plot(1908:1941,nanmean(b(:,[1908:1941]-1849),1)+0.3,'k--','linewi',3)
CDF_panel([1908 1941 -1.2 1.2],[],...
{'HadSST3','ICOADS2.5 raw (bucket + eri)','ICOADS3.0 raw (bucket + eri)'},...
'year','Atlantic SST anomaly(^oC)');

subplot(2,2,2); hold on
plot(1908:1941,nanmean(b(:,[1908:1941]-1849),1)+0.3,'k--','linewi',3)
b = HM_function_mask_average(a.SSTE_raw,[-87.5:5:87.5],mask_out(:,:,2));
plot([1930:1941],nanmean(b(:,[1930:1941]-1929),1)+0.3,'k-','linewi',3)
b = HM_function_mask_average(aa.SST_Raw,[-87.5:5:87.5],mask_out(:,:,2));
plot(1908:1941,nanmean(b(:,[1908:1941]-1849),1)+0.3,'linewi',2)
b = HM_function_mask_average(aa.SST_RC,[-87.5:5:87.5],mask_out(:,:,2));
plot(1908:1941,nanmean(b(:,[1908:1941]-1849),1)+0.3,'linewi',2)
b = HM_function_mask_average(aa.SST_GCRC,[-87.5:5:87.5],mask_out(:,:,2));
plot(1908:1941,nanmean(b(:,[1908:1941]-1849),1)+0.3,'linewi',2)
CDF_panel([1908 1941 -1.2 1.2],[],...
{'ICOADS3.0 raw (bucket + eri)','ICOADS3.0 raw (eri)','ICOADS3.0 raw (bucket)',...
'ICOADS3.0 LME (bucket)','ICOADS3.0 LME + RC (bucket)'},...
'year','Atlantic SST anomaly(^oC)');

subplot(2,2,3); hold on
plot(1908:1941,squeeze(SST([1908:1941]-1849,1,4)),'linewi',2)
plot(1908:1941,squeeze(SST([1908:1941]-1849,1,5)),'linewi',2)
b = HM_function_mask_average(a.SSTM_raw,[-87.5:5:87.5],mask_out(:,:,1));
plot(1908:1941,nanmean(b(:,[1908:1941]-1849),1)+0.2,'k--','linewi',3)
CDF_panel([1908 1941 -1.6 0.4],[],{},'year','Pacific SST anomaly(^oC)');

subplot(2,2,4); hold on
plot(1908:1941,nanmean(b(:,[1908:1941]-1849),1)+0.2,'k--','linewi',3)
b = HM_function_mask_average(a.SSTE_raw,[-87.5:5:87.5],mask_out(:,:,1));
plot([1930:1941],nanmean(b(:,[1930:1941]-1929),1)+0.2,'k-','linewi',3)
b = HM_function_mask_average(aa.SST_Raw,[-87.5:5:87.5],mask_out(:,:,1));
plot(1908:1941,nanmean(b(:,[1908:1941]-1849),1)+0.2,'linewi',2)
b = HM_function_mask_average(aa.SST_RC,[-87.5:5:87.5],mask_out(:,:,1));
plot(1908:1941,nanmean(b(:,[1908:1941]-1849),1)+0.2,'linewi',2)
b = HM_function_mask_average(aa.SST_GCRC,[-87.5:5:87.5],mask_out(:,:,1));
plot(1908:1941,nanmean(b(:,[1908:1941]-1849),1)+0.2,'linewi',2)
CDF_panel([1908 1941 -1.6 .4],[],{},'year','Pacific SST anomaly(^oC)');





subplot(2,2,2); hold on
plot(squeeze(SST([1908:1941]-1849,1,4:5)),'linewi',2)
b = HM_function_mask_average(a.SSTM_raw,[-87.5:5:87.5],mask_out(:,:,1));
plot(nanmean(b(:,[1908:1941]-1849),1)+0.13,'linewi',2)

b = HM_function_mask_average(a.SSTB_raw,[-87.5:5:87.5],mask_out(:,:,2));
plot(nanmean(b(:,[1908:1941]-1849),1)+0.13,'linewi',2)


squeeze(CDC_corr(repmat(AT([1908:1941]-1849,:),1,1,4),SST([1908:1941]-1849,:,:)))
%% **************************************************
% Compute regional average                         **
% ***************************************************
MASK = HM_function_mask_coastal;
clear('TS')
for ct= 1:2
    TS(:,:,1,ct) = HM_function_mask_average(CRUT,[-87.5:5:87.5],MASK==ct);
    TS(:,:,2,ct) = HM_function_mask_average(SST_GCRC,[-87.5:5:87.5],MASK==ct);
    TS(:,:,3,ct) = HM_function_mask_average(SST_GC,[-87.5:5:87.5],MASK==ct);
end

%% **************************************************
% Compute the correlation and randomize for test  **
% **************************************************
figure(1); clf;
ly_out = 3;

for ct = 1:2;

    subplot(ly_out,2,[ct ct+2]); hold on;
    yr_list = 1908:1941;
    avg = [1920:1930]-1907;

    % ICOADSb
    i = 2;
    a(i,:) = nanmean(TS(:,[yr_list] - 1849,i,ct),1);
    h(1) = plot(yr_list,a(i,:) - nanmean(a(i,avg)),'linewi',2,'color',[0 .4 1]);
    xlim([yr_list(1) yr_list(end)])

    % ICOADSa
    i = 3;
    a(i,:) = nanmean(TS(:,[yr_list] - 1849,i,ct),1);
    h(2) = plot(yr_list,a(i,:) - nanmean(a(i,avg)),'linewi',3,'color',[1 1 1]*.75);

    % CTUR4
    i = 1;
    a(i,:) = nanmean(TS(:,[yr_list] - 1849,i,ct),1);
    h(3) = plot(yr_list,a(i,:) - nanmean(a(i,avg)),'linewi',2,'color',[1 .4 0]*0);

    if ct == 1
        legend(h,{'ICOADSb','ICOADSa','CRUTEM4'},'fontsize',15,...
            'fontweight','bold','location','southeast')
    end

    CDF_panel([1908 1941 -1.2 1],[char(64+ct+32)],[],'Year','T anomaly (^oC)')
    CDC_corr(a(2,:),a(1,:))
    CDC_corr(a(3,:),a(1,:))
end

subplot(ly_out,2,5:6); hold on;
CDF_plot_map('pcolor',double(ismember(MASK,[1, 2])),...
            'crange',[0 1],'region',[30 390 12.5 67.5],...
            'plabel','c')
colormap(gca,[1 1 1; .6 .6 .6]);
colorbar off

set(gcf,'position',[15 8 14 9]*1.4,'unit','inches')
set(gcf,'position',[1 18 15 9]*1,'unit','inches')
