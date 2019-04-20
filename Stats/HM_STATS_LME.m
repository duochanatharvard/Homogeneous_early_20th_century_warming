clear;

varname = 'SST';
method  = 'Bucket';

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

% ******
% O/I **
% ******
if ~exist('env','var'),
    env = 1;            % 1 means on odyssey
end

dir_home = HM_OI('home',env);
app = ['HM_',varname,'_',method];
if app(end)=='_', app(end)=[]; end
app(end+1) = '/';
dir_load = [dir_home,app];

read_app = ['_rmdup_',...
            num2str(EP.do_rmdup),'_rmsml_',num2str(EP.do_rmsml),...
            '_fewer_first_',num2str(EP.do_fewer_first),...
            '_correct_kobe_',num2str(EP.do_add_JP),...
            '_connect_kobe_',num2str(EP.connect_kobe)];

dir_bin  = [dir_load,HM_OI('LME_run')];
file_lme = [dir_bin,'LME_',app(1:end-1),'_yr_start_',num2str(EP.yr_start),...
            '_deck_level_',num2str(do_NpD),'_',app_exp,read_app,'.mat'];

load(file_lme,'out');

% ************************************************************
% Repeat offsets to have annual resolution
% ************************************************************
for i =  1:5
    out.bias_decade_annual(i:5:165,:) = out.bias_decade;
    out.bias_decade_rnd_annual(i:5:165,:,:) = out.bias_decade_rnd;
end

% ************************************************************
% Numbers in Table S1
% ************************************************************
if 0,
    l = any(~isnan(a([1908:1941]-1849,:)),1);
    num2str(out.bias_fixed(l),'%6.2f')
    un = CDC_std(out.bias_fixed_random(:,l),1)';
    p  = 2*(1-normcdf(abs(out.bias_fixed(l)./un),0,1));
    nnz(p<0.05)
    nnz(p<0.05/46)

    [out.bias_fixed(l)  p<0.05   p<0.05/46 p]
end

% ************************************************************
% Deck 118: changes in offsets
% ************************************************************
id = find(out.unique_grp(:,3) == 118);
yrs = 1935:1941;
a1 = nanmean(out.bias_decade_annual(yrs-1849,id)) + out.bias_fixed(id) + nanmean(out.bias_region([2 3 5],id));
c1 = squeeze(nanmean(out.bias_decade_rnd_annual(yrs-1849,id,:))) + squeeze(out.bias_fixed_random(:,id)) + squeeze(nanmean(out.bias_region_rnd([2 3 5],id,:)));

yrs = 1908:1930;
a2 = nanmean(out.bias_decade_annual(yrs-1849,id)) + out.bias_fixed(id) + nanmean(out.bias_region([2 3 5],id));
c2 = squeeze(nanmean(out.bias_decade_rnd_annual(yrs-1849,id,:))) + squeeze(out.bias_fixed_random(:,id)) + squeeze(nanmean(out.bias_region_rnd([2 3 5],id,:)));

a1 - a2
CDC_std(c1-c2,1) * 2

a1 
CDC_std(c1,1) * 2

a2 
CDC_std(c2,1) * 2

% ************************************************************
% Deck 156: mean offsets
% ************************************************************
id = find(out.unique_grp(:,3) == 156);
yrs = 1908:1912;
nanmean(out.bias_decade_annual(yrs-1849,id)) + out.bias_fixed(id) + nanmean(out.bias_region([1 4],id))
c = squeeze(nanmean(out.bias_decade_rnd_annual(yrs-1849,id,:))) + squeeze(out.bias_fixed_random(:,id)) + squeeze(nanmean(out.bias_region_rnd([1 4],id,:)));
CDC_std(c,1) * 2

% ************************************************************
% DE Deck 192: trend
% ************************************************************
id = find(ismember(out.unique_grp,['DE',192],'rows'));
yrs = 1920:1941;
a = out.bias_decade_annual(yrs-1849,id) + out.bias_fixed(id);
b = squeeze(out.bias_decade_rnd_annual(yrs-1849,id,:)) + repmat(out.bias_fixed_random(:,id)',numel(yrs),1);
c = CDC_trend(a,1:numel(yrs),1);
d = CDC_trend(b,1:numel(yrs),1);
c{1} * numel(yrs)
CDC_std(d{1} * numel(yrs),2) * 2
