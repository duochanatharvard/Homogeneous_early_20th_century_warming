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
% EP.connect_kobe  = 1;
% EP.do_focus = 1;


P = HM_lme_exp_para(varname,method);
key = 1e5;                                   % A threshold to combine groups
                                             % in the display
do_lower_case = 1;                           % lower case for panel labels

% ****************************
% Find the LME file to read
% ****************************
dir_home = HM_OI('home');
app = ['HM_',varname,'_',method];
if app(end)=='_', app(end)=[]; end
app(end+1) = '/';
dir_stats = [dir_home,app];
file_stats = [dir_stats,'Stats_',app(1:end-1),...
              '_deck_level_',num2str(do_NpD),'.mat'];
load(file_stats);

% ****************************************
% Combine statistics of Kobe decks
% ****************************************
if EP.connect_kobe == 1,
    pst = find(ismember(unique_grp,['JP',118;'JP' 119;'JP' 762],'rows'));
    Stats_glb(:,:,pst(1)) = nansum(Stats_glb(:,:,pst),3);
    Stats_map(:,:,:,pst(1)) = nansum(Stats_map(:,:,:,pst),4);
    Stats_glb(:,:,pst(2:end)) = [];
    Stats_map(:,:,:,pst(2:end)) = [];
    unique_grp(pst(2:end),:) = [];
end

% ************************************
% Prepare and save the color scheme **
% ************************************
col_raw = HM_Fig_1_color_scheme(varname,method,do_NpD,key,1,EP);

% **********************************
% Prepare for annual # of samples **
% **********************************
Stats_ann = squeeze(nansum(Stats_glb,2))';
logic_pic = nansum(Stats_ann,2) > key;

data_pic  = Stats_ann(logic_pic,:);
grp_pic   = unique_grp(logic_pic,:);
col_pic = col_raw(logic_pic,:);

data_pic(end+1,:) = nansum(Stats_ann(~logic_pic,:),1);
if size(grp_pic,2) == 3,
    grp_pic(end+1,:)   = 'OT ';
else
    grp_pic(end+1,:)   = 'OT';
end
col_pic(end+1,:) = [.3 .3 .3]+0.15;

% *******************************
% Resort the sequence of plots **
% *******************************
g = grp_pic(:,1:2);
I = [find(ismember(g,'GB','rows'))', find(ismember(g,'NL','rows'))',...
     find(ismember(g,'JP','rows'))', find(ismember(g,'US','rows'))',...
     find(ismember(g,'DE','rows'))', find(ismember(g,'RU','rows'))', ...
     find(ismember(g,['BE';'BR';'CA';'FR';'HR'],'rows'))', find(g(:,1)>100)', size(g,1)];
data_pic = data_pic(I,:);
col_pic = col_pic(I,:);
grp_pic = grp_pic(I,:);

% ***************************
% Compute the bucket ratio **
% ***************************
N = size(Ratio,2);
ratio = nansum(reshape(Ratio(1,:),12,N/12),1) ./ ...
        nansum(reshape(Ratio(2,:),12,N/12),1);
Total = nansum(reshape(Ratio(2,:),12,N/12),1);

% **************************
% Generate Panel a
% ***************************
figure(1); clf;
subplot(1,2,1); hold on;
bar(1850:1:2014,Total,'facecolor',[1 1 1]*0,'edgecolor','none','barwidth',1);
CDF_bar_stack(P.yr_list,data_pic,col_pic);
CDF_panel([1907.5 1941.5 0 12e5],[],{},'Year',...
    'Number of bucket measurements','fontweight','normal');
text(1909,11*1e5,char(65+do_lower_case*32),'fontsize',28,'fontweight','bold');
CDF_histplot(1850.5:2014.5,ratio*1e6,'-','w',5);
CDF_histplot(1850.5:2014.5,ratio*1e6,'-','k',2);
for i = 0:2e5:10e5
    text(1942.2,i,num2str(i/1e4),'fontsize',18,'fontweight','normal');
end
text(1946,0e5,'Percentage of bucket measurements','fontsize',20,'fontweight','normal','rotation',90);
set(gca,'xtick',[1910:5:1940])
set(gcf,'position',[1 1 15 5]*1.2,'unit','inches');
set(gcf,'position',[1 1 15 5]*1.2,'unit','inches');
set(gca,'fontsize',18);

% ****************************************************************
% A list of decks that appear from 1908-1941
% ****************************************************************
l_contribute = any(Stats_ann(:,[1908:1941]-1849) > 20 , 2);
deck_bf = unique_grp(l_contribute,:);
I = ismember(grp_pic,deck_bf,'rows');
data_pic = [data_pic(I,:); data_pic(end,:)];
col_pic  = [col_pic(I,:); col_pic(end,:); 0 0 0];
grp_pic  = [grp_pic(I,:); grp_pic(end,:)];

% **************************
% Generate legends
% ***************************
subplot(1,2,2); hold on;
nnn = 2;      % number of columns
N = size(data_pic,1);
for i = 1:N+1
    if i <= N,
        [yy,xx] = ind2sub([ceil(N/nnn), nnn],i);
    else
        yy = 13;
        xx = 2;
    end
    if i < N
        if grp_pic(i,1) < 100,
            temp_text = [grp_pic(i,1:2),'  DCK  ',num2str(grp_pic(i,3))];
        else
            temp_text = ['----  DCK  ',num2str(grp_pic(i,3))];
        end
    elseif i == N,
        temp_text = 'Other Groups';
    else
        temp_text = 'Non Buckets';
    end
    patch([xx xx+0.2 xx+0.2 xx],-[yy yy yy+0.8 yy+0.8]+0.4,col_pic(i,:),'linest','none');
    h = text(0.3+xx,-yy,temp_text);
    set(h,'fontsize',14,'fontweight','normal');
end
axis off
axis([0.9 nnn+1.2   -floor(N/nnn)-2 0]);
set(gcf,'position',[1 1 15 5]*1.2,'unit','inches');
set(gcf,'position',[1 1 15 5]*1.2,'unit','inches');
set(gcf,'color','w');
set(gcf, 'PaperPositionMode','auto');

% *********************************
% Generate Gridded ship counts   **
% *********************************
if strcmp(method,'Bucket'),
    list = [1908 1918; 1919 1928; 1929 1941];
end

figure(2); clf; hold on;
for ct = 1:size(list,1)

    
    num_temp = squeeze(nansum(Stats_map(:,:,[list(ct,1):list(ct,2)] - P.yr_list(1)+1,:),3));
    NN = nansum(num_temp,3);

    for i = 1:size(num_temp,3)
        num_temp(:,:,i) = CDC_smooth2(num_temp(:,:,i));
    end

    num_temp(num_temp == 0) = nan;
    [~,Ship_deck] = max(num_temp,[],3);
    Ship_deck(NN < 100 | isnan(NN)) = nan;

    subplot(1,3,ct); hold on;
    CDF_plot_map('pcolor',Ship_deck,'plabel',[char(65+ct+do_lower_case*32)],...
      'region',[ 30 390 -60 70 ],'fontsize',18,'bckgrd','w','xtick',[90 180 270 360]);
    colormap(gca,col_raw);
    caxis([0.5 size(unique_grp,1)+0.5]);
    colorbar off;
end

set(gcf,'position',[1 1 15 5]*1.2,'unit','inches');
set(gcf,'position',[1 1 15 5]*1.2,'unit','inches');
