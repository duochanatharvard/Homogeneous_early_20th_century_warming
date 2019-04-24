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
EP.do_focus = 1;
EP.yr_start = 1850;
P = HM_lme_exp_para(varname,method);
yr_grid = P.yr_list(1) - 1;
P = HM_correct_para;
yr_start = P.yr_list(1);
yr_end   = P.yr_list(end);
shft = 12;
do_lower_case = 1;
app_version = 'corr_err';

% ************************************
% Input / Output                    **
% ************************************
app = ['HM_',varname,'_',method];
if app(end)=='_', app(end)=[]; end
app(end+1) = '/';

dir_home = HM_OI('home',env);
dir_load = [dir_home,app];
dir_mis  = [dir_home,HM_OI('mis',env)];

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
file_mis = [dir_mis,'1908_1941_Trd_TS_and_pdo_from_all_existing_datasets_20190424.mat'];

% ************************************
% Load data                         **
% ************************************
cor_idv = load(file_idv,'Main_TS','Save_TS');
cor_rnd = load(file_rnd,'Save_TS');

other_ds = load(file_mis,'cobesst2','ersst5','hadsst3','hadsst3_en','hadisst2');

pic_main = squeeze(nanmean(cor_idv.Main_TS,1));
pic_idv  = squeeze(nanmean(cor_idv.Save_TS,1));
pic_rnd  = squeeze(nanmean(cor_rnd.Save_TS,1));


% ***************************************************
% Figure: Time series of individual regions       **
% ***************************************************
figure(1); clf;
for reg = 1:2
    subplot(2,1,reg), hold on;

    pic_t = yr_start:yr_end;
    pic = squeeze(pic_rnd([yr_start : yr_end] - yr_grid,reg,:))';
    pic = pic - repmat(nanmean(pic(:,[1:10]+shft),2),1,numel(pic_t));
    pic_all = pic_main([yr_start: yr_end] - yr_grid,reg,2)';
    pic_all = pic_all - repmat(nanmean(pic_all(:,[1:10]+shft),2),1,numel(pic_t));
    pic_raw = pic_main([yr_start: yr_end] - yr_grid,reg,1);

    clear('pic_otds')
    if strcmp(varname,'SST'),
        pic_otds(1,:) = pic_raw;
        pic_otds(2,:) = nanmean(other_ds.hadsst3.ts(:,pic_t - other_ds.hadsst3.time(1) + 1,reg),1);
        pic_otds(3,:) = nanmean(nanmean(other_ds.hadisst2.ts(:,pic_t - other_ds.hadisst2.time(1) + 1,reg,:),1),4);
        pic_otds(4,:) = nanmean(other_ds.ersst5.ts(:,pic_t - other_ds.ersst5.time(1) + 1,reg),1);
        pic_otds(5,:) = nanmean(other_ds.cobesst2.ts(:,pic_t - other_ds.cobesst2.time(1) + 1,reg),1);
        pic_otds_rnd = squeeze(nanmean(other_ds.hadsst3_en.ts(:,pic_t - other_ds.hadsst3_en.time(1) + 1,reg,:),1))';
        pic_otds_rnd = pic_otds_rnd - repmat(nanmean(pic_otds_rnd(:,[1:10]+shft),2),1,numel(pic_t));
        pic_hadisst2 = squeeze(nanmean(other_ds.hadisst2.ts(:,pic_t - other_ds.hadisst2.time(1) + 1,reg,:),1))';
        pic_hadisst2 = pic_hadisst2 - repmat(nanmean(pic_hadisst2(:,[1:10]+shft),2),1,numel(pic_t));
    end
    pic_otds = pic_otds - repmat(nanmean(pic_otds(:,[1:10]+shft),2),1,numel(pic_t));

    if strcmp(varname,'SST'),
        CDF_patch(pic_t,pic_otds_rnd,[1 .6 .6],0.0455);
        CDF_patch(pic_t,pic,[.6 .7 1],0.0455);
        CDF_patch(pic_t,pic_hadisst2,[1 .8 .6],0.00000001);
    end

    col_ot = [         0         0         0
                       1         0         0
                      .8        .6         0
                  0.3333    0.3333    0.3333
                  0.6667    0.6667    0.6667];

    for ct = [1 size(pic_otds,1):-1:2]
        if rem(ct,2) == 0 || ct == 1,
            line_st = '-';
        else
            line_st = '-';
        end
        h(ct+1) = plot(pic_t,pic_otds(ct,:),line_st,'linewi',2,'color',col_ot(ct,:));
    end

    if strcmp(varname,'SST'),
        h(1) = plot(pic_t,pic_all,'linewi',3,'color',[0 .425 0.9]);
    end

    if reg == 1,
        if strcmp(varname,'SST'),
            legend(h,{'ICOADSb','ICOADSa','HadSST3','HadISST2','ERSST5','COBESST2'}, ...
                                'fontsize',12','fontweight','bold','location','northwest')
        end
    end

    if reg == 1,
        CDF_panel([yr_start yr_end -0.5 .6],[''],{},'Year',['NP ',varname,' anomaly (^oC)']);
    else
        CDF_panel([yr_start yr_end -0.5 .6],[''],{},'Year',['NA ',varname,' anomaly (^oC)']);
    end

    set(gca,'fontsize',14)

    if reg == 1;
        if strcmp(varname,'SST'),
            text(1919,0.7-.2,char(64+reg+do_lower_case*32),'fontsize',20,'fontweight','bold');
        end
    else
        text(1909,0.7-.2,char(64+reg+do_lower_case*32),'fontsize',20,'fontweight','bold');
    end
end

set(gcf,'position',[1 1 8 10]*.9,'unit','inches')
set(gcf,'position',[1 1 8 10]*.9,'unit','inches')
