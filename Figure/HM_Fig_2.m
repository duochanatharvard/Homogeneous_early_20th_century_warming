clear;              
do_NpD = 1;
env = 0;
yint = 1;
app_version = 'cor_err';
do_sort = 1;
num_col = 3;
ysrt = 1850;
alpha    = 0.05;
varname = 'SST';
method = 'Bucket';

% *******************************************************
% Read Data   
% *******************************************************
dir_home = HM_OI('home',env);
app = ['HM_',varname,'_',method];
if app(end)=='_', app(end)=[]; end
app(end+1) = '/';

EP.do_rmdup = 0;
EP.do_rmsml = 0;
EP.do_add_JP = 0;
EP.do_fewer_first = 0;
EP.connect_kobe = 1;
EP.yr_start = 1850;
app_exp = 'cor_err';

read_app = ['_rmdup_',...
            num2str(EP.do_rmdup),'_rmsml_',num2str(EP.do_rmsml),...
            '_fewer_first_',num2str(EP.do_fewer_first),...
            '_correct_kobe_',num2str(EP.do_add_JP),...
            '_connect_kobe_',num2str(EP.connect_kobe)];

dir_load = [dir_home,app];
dir_bin  = [dir_load,HM_OI('LME_run')];
file_lme = [dir_bin,'LME_',app(1:end-1),'_yr_start_',num2str(EP.yr_start),...
            '_deck_level_',num2str(do_NpD),'_',app_exp,read_app,'.mat'];

disp(file_lme)

clear('out','test_mean','test_random')
load(file_lme,'out')

NY = size(out.bias_decade,1);
for i =  1:5
    out.bias_decade_annual(i:5:NY*5,:) = out.bias_decade;
    out.bias_decade_rnd_annual(i:5:NY*5,:,:) = out.bias_decade_rnd;
end
out.bias_decade = out.bias_decade_annual;
out.bias_decade_rnd = out.bias_decade_rnd_annual;
out.bias_decade(end+1:165,:) = nan;
out.bias_decade_rnd(end+1:165,:,:) = nan;

N_group = size(out.unique_grp,1);
N_rnd   = size(out.bias_fixed_random,1);

fixed_mean   = repmat(out.bias_fixed,1,165)';
test = fixed_mean + out.bias_decade;

%% *******************************************************
% Find nations that are to be marked by '*' or '**'    **
% *******************************************************
if yint == 1,
    temp = out.bias_fixed_random;
    temp  = temp - repmat(nanmean(temp,1),size(temp,1),1);
    out.bias_fixed_std = sqrt(nansum(temp.^2,1) / (size(temp,1) - 1))';
end
Z_stats = (1 - normcdf(abs(out.bias_fixed ./ out.bias_fixed_std)))*2;
Sig_Nat_90 = Z_stats < alpha;
Sig_Nat_BF = Z_stats < alpha/numel(Z_stats);
List_Nat = out.unique_grp;

%% ***************************************************************************
% Add a section that reads the number of measurements from individual groups
% ***************************************************************************
dir_home = HM_OI('home',env);
app = ['HM_',varname,'_',method];
if app(end)=='_', app(end)=[]; end
app(end+1) = '/';
dir_stats = [dir_home,app];
file_stats = [dir_stats,'Stats_',app(1:end-1),...
              '_deck_level_',num2str(do_NpD),'.mat'];
load(file_stats,'unique_grp','Stats_glb');
pst = find(ismember(unique_grp,['JP',118;'JP' 119;'JP' 762],'rows'));
Stats_glb(:,:,pst(1)) = nansum(Stats_glb(:,:,pst),3);
Stats_glb(:,:,pst(2:end)) = [];
unique_grp(pst(2:end),:) = [];

Stats_glb = squeeze(nansum(Stats_glb,2));

%% *******************************************************
% Prepare Data to be plotted                           **
% *******************************************************
if do_sort == 1;
    [~,I] = sort(out.bias_fixed);
    test = test(:,I);
    Stats_glb = Stats_glb(:,I);
    Sig_Nat_90 = Sig_Nat_90(I);
    Sig_Nat_BF = Sig_Nat_BF(I);
    List_Nat   = List_Nat(I,:);
    
    l = nansum(~isnan(test),1) > 1;
    test = test(:,l);
    Stats_glb = Stats_glb(:,l);
    Sig_Nat_90 = Sig_Nat_90(l);
    Sig_Nat_BF = Sig_Nat_BF(l);
    List_Nat   = List_Nat(l,:);
end

%% *******************************************************
% Find the color scheme                                **
% *******************************************************
col = colormap_CD([ .5 .67; .05 0.93],[.9 .2],[0 0],10);
cc  = discretize(test',[-inf -0.45:0.05:0.45 inf]);
wid = (log10(Stats_glb')+1)/15;

% ********************************************
% A list of decks that appear from 1908-1941
% ********************************************
l = any(~isnan(out.bias_decade([1908:1941]-1849,:)),1);
deck_bf = out.unique_grp(l,:);

%% *******************************************************
% Generate Figures                                     **
%% *******************************************************
figure(1);clf;hold on;
num_row = 20;
pic = test';

if do_NpD == 0,
    out_ly = CDF_layout([num_row,3],{[1 18 1 3],[num_row num_row 1 3]});
else
    out_ly = CDF_layout([num_row,3],{[1 18 1 1],[1 18 2 2],[1 18 3 3],[num_row num_row 1 3]});
end

if yint == 1 && strcmp(method,'Bucket'),
    for i = 1:3
        subplot(num_row,3,out_ly{i}), hold on
        h = patch([1908 1941 1941 1908],[-60 -60 0 0],[1 1 1]*.7);
        set(h,'EdgeColor','none','facealpha',0.5);
    end
end

for i = 1:size(pic,1)
    [p1,p2] = ind2sub([ceil(size(test,2)/num_col), num_col],i);
    
    subplot(num_row,3,out_ly{p2}),
    for j = 1:size(pic,2)
        if ~isnan(cc(i,j)),
            patch(ysrt + [0 1 1 0]*yint + yint * (j-1),[-1 -1 1 1]*wid(i,j) - p1,...
                col(cc(i,j),:),'linest','none');
        end
    end
    
    if Sig_Nat_BF(i),
        surfix = '** ';
    elseif Sig_Nat_90(i),
        surfix = '* ';
    else
        surfix = '';
    end
    
    if do_NpD == 1,
        if ismember(List_Nat(i,:),deck_bf,'rows'),
            surfix_col = '\color[rgb]{0,0,0} ';
        else
            surfix_col = '\color[rgb]{.4,.4,.4} ';
        end
    end
    
    if do_NpD == 0,
        if all(List_Nat(i,1) > 100),
            y_label_text{i} = [surfix,'D ',num2str(List_Nat(i,1))];
        else
            y_label_text{i} = [surfix,char(List_Nat(i,1:2))];
        end
        set(gca,'ytick',[-ceil(size(test,2)/num_col):1:-1],'yticklabel',fliplr(y_label_text));
        set(gca,'fontsize',8);
    else
        if all(List_Nat(i,1) > 100),
            y_label_text{i,p2} = [surfix_col, surfix,'---- Dck ',num2str(List_Nat(i,1))];
        else
            y_label_text{i,p2} = [surfix_col, surfix,char(List_Nat(i,1:2)),' Dck ',num2str(List_Nat(i,3))];
        end
        set(gca,'fontsize',10);
    end
    
    CDF_panel([1850 2015 -ceil(size(test,2)/num_col)-1 -0],[],{},'Year','');
    set(gca,'xtick',1850:10:2010,'xticklabel',{'1850','','','','','1900','','','','','1950','','','','','2000',''});
    
    set(gca,'fontsize',12,'fontweight','Normal');
end

%%

NN = ceil(size(test,2)/num_col);

if yint == 1,
    for i = 1:3
        subplot(num_row,3,out_ly{i}),
        lgd_text = flipud(y_label_text((i-1)*NN+1:i*NN,i));
        set(gca,'ytick',[-ceil(size(test,2)/num_col):1:-1],'yticklabel',lgd_text);
    end
end

%%
figure(1);
subplot(num_row,3,out_ly{end}),
for i = 1:size(col,1)
    patch([0 1 1 0]+i - 1,[0 0 1 1],col(i,:),'linewi',1);
end
set(gca,'xtick',0:2:20,'xticklabel',[-0.5:0.1:0.5]);
set(gca,'ytick',[]);
set(gca,'fontsize',16,'fontweight','normal')
if do_NpD == 0,
    if ~strcmp(method,'ERI'),
        xlabel('SST offsets between nations (^oC)');
    else
        xlabel('ERI SST offsets between nations (^oC)');
    end
else
    if ~strcmp(method,'ERI'),
        xlabel('Bucket SST offsets between groups (^oC)')
    else
        xlabel('ERI SST offsets between groups (^oC)')
    end
end
set(gcf,'color','w')
