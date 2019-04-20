clear;

% ********************************************************************
% Do not change any parameters except ```env```
% ********************************************************************
env = 0;

varname = 'SST';
method = 'Bucket';
do_NpD = 1;
EP.do_rmdup = 0;
EP.do_add_JP = 0;
EP.connect_kobe = 1;
EP.yr_start = 1850;
alpha = 0.05;
reso_x = 5;
reso_y = 5;
do_lower_case = 1;
scale = 3.4;

% ***********************************
% Input / Output
% ***********************************
if ~exist('env','var'),
    env = 1;                             % 1 means on odyssey
end
dir_home = HM_OI('home',env);

app = ['HM_',varname,'_',method];
if app(end)=='_', app(end)=[]; end
app(end+1) = '/';

% ********************************************************************
% Read trd files in correction and randomized correction
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

load(file_idv,'Main_trd')
load(file_rnd,'Save_trd')

% ********************************************************************
% Read Trends from other datasets
% ********************************************************************
file_otds = [HM_OI('Mis',env),'1908_1941_Trd_TS_and_pdo_from_all_existing_datasets_20180914.mat'];
other_ds  = load(file_otds,'hadsst3_en','sampling','hadsst3');

% ********************************************************************
% Do significance test
% ********************************************************************
data_gc_rnd = repmat(other_ds.hadsst3_en.trd,1,1,10) - repmat(other_ds.hadsst3.trd,1,1,1000);
data_in = repmat(Main_trd(:,:,1),1,1,size(other_ds.sampling.trd,3)) + other_ds.sampling.trd + data_gc_rnd;
sig_raw   = HM_function_sig_member(data_in,Main_trd(:,:,1),alpha);

data_in = Save_trd - repmat(Main_trd(:,:,1),1,1,size(other_ds.sampling.trd,3));
sig_cor = HM_function_sig_member(data_in,Main_trd(:,:,2) - Main_trd(:,:,1),alpha);

data_in = Save_trd + other_ds.sampling.trd;
sig_cored = HM_function_sig_member(data_in,Main_trd(:,:,2),alpha);

% ********************************************************************
% Figure: Trends
% ********************************************************************
figure(1); clf; hold on;
for i = 1:3

    figure(i);clf; hold on;

    col = [ 20 0 113; 25 1 153; 24 5 190; 22 16 223; 62 73 233; 110 127 233;...
            153 170 235; 190 204 239; 224 232 246; 255 255 255;...
            255 255 255; 246 239 224; 239 218 190; 235 193 153; 233 162 110;...
            233 122 61; 233 77 19; 190 43 8; 154 14 3; 113 1 0] / 255;

    switch i,
        case 1,
            temp_sig = sig_raw;
            bartit = ['ICOADSa (^oC/',num2str(scale*10),' years)'];
            CDF_plot_map('pcolor',Main_trd(:,:,1) * scale,'crange',1.667,'cnum',20,...
                         'plabel',[char(64+i+do_lower_case*32)],'plcol','w',...
                         'region',[30 390 -80 80],'bartit',bartit);
            colormap(gca,col);

        case 2,
            temp_sig = sig_cor;
            CDF_plot_map('pcolor',(Main_trd(:,:,2) - Main_trd(:,:,1))* scale,...
                         'crange',0.4,'cnum',20, 'plabel',[char(64+i+do_lower_case*32)],...
                         'plcol','w','region',[30 390 -80 80],'bartit',...
                         ['Regional Correction (^oC/',num2str(scale*10),' years)']);
            colormap(gca,col);

        case 3,
            temp_sig = sig_cored;
            bartit = ['ICOADSb (^oC/',num2str(scale*10),' years)'];
            CDF_plot_map('pcolor',Main_trd(:,:,2) * scale,'crange',1.667,'cnum',20,...
                         'plabel',[char(64+i+do_lower_case*32)],'plcol','w',...
                         'region',[30 390 -80 80],'bartit',bartit);
            colormap(gca,col);
    end

    % Plot significance ********************************************************
    for ii = 1:(360/reso_x)
        for jj = 1:(180/reso_y)
            if temp_sig(ii,jj) == -1
                if ii*reso_x-reso_x/2 < 30,
                    m_plot(ii*reso_x-reso_x/2+360,jj*reso_y-reso_y/2-90,'kv','markersize',4);
                else
                    m_plot(ii*reso_x-reso_x/2,jj*reso_x-reso_x/2-90,'kv','markersize',4);
                end
            elseif temp_sig(ii,jj) == 1
                if ii*reso_x-reso_x/2 < 30,
                    m_plot(ii*reso_x-reso_x/2+360,jj*reso_y-reso_y/2-90,'k+','markersize',6);
                else
                    m_plot(ii*reso_x-reso_x/2,jj*reso_x-reso_x/2-90,'k+','markersize',6);
                end
            end
        end
    end

    daspect([1 .8 1]);
    set(gcf,'position',[1 1 10 8]*.95,'unit','inches')
    set(gcf,'position',[1 1 10 8]*.95,'unit','inches')
end
