HM_load_package;

% Uncomment the following lines 
% if you are not using Quick_start.m to access this script
% 
% varname = 'SST';
% method  = 'Bucket';
% 
% do_NpD = 1;
% app_exp = 'cor_err';
% EP.do_rmdup = 0;
% EP.do_rmsml = 0;
% EP.sens_id  = 0;
% EP.do_fewer_first = 0;
% EP.connect_kobe   = 1;
% EP.do_add_JP = 0;
% EP.yr_start = 1850;

% ******
% O/I **
% ******
dir_home = HM_OI('home');
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
% Deck 118: changes in offsets
% ************************************************************
id = find(out.unique_grp(:,3) == 118);
yrs = 1935:1941;
a1 = nanmean(out.bias_decade_annual(yrs-1849,id)) + out.bias_fixed(id) + nanmean(out.bias_region([2 3 5],id));
c1 = squeeze(nanmean(out.bias_decade_rnd_annual(yrs-1849,id,:))) + squeeze(out.bias_fixed_random(:,id)) + squeeze(nanmean(out.bias_region_rnd([2 3 5],id,:)));

yrs = 1908:1930;
a2 = nanmean(out.bias_decade_annual(yrs-1849,id)) + out.bias_fixed(id) + nanmean(out.bias_region([2 3 5],id));
c2 = squeeze(nanmean(out.bias_decade_rnd_annual(yrs-1849,id,:))) + squeeze(out.bias_fixed_random(:,id)) + squeeze(nanmean(out.bias_region_rnd([2 3 5],id,:)));

disp(['----------------------------------------------------------'])
disp([' '])
disp(['The mean offset of Japanese Cobe Collection measurements'])
disp(['over the NP from 1908-1930 is ',num2str(a2,'%6.2f'),'C,'])
disp(['and its 2 s.d. uncertainty is ',num2str(CDC_std(c2,1) * 2,'%6.2f'),'C.'])
disp([' '])
disp(['The mean offset of Japanese Cobe Collection measurements'])
disp(['over the NP from 1935-1941 is ',num2str(a1,'%6.2f'),'C,'])
disp(['and its 2 s.d. uncertainty is ',num2str(CDC_std(c1,1) * 2,'%6.2f'),'C.'])
disp([' '])
disp(['Changes in the mean offsets of Japanese Cobe Collection measurements'])
disp(['over the NP from 1908-1930 to 1935-1941 is ',num2str(a1 - a2,'%6.2f'),'C,'])
disp(['and its 2 s.d. uncertainty is ',num2str(CDC_std(c1 - c2,1) * 2,'%6.2f'),'C.'])
disp([' '])
disp(['----------------------------------------------------------'])
disp([' '])

% ************************************************************
% Deck 156: mean offsets
% ************************************************************
id = find(out.unique_grp(:,3) == 156);
yrs = 1908:1912;
a = nanmean(out.bias_decade_annual(yrs-1849,id)) + out.bias_fixed(id) + nanmean(out.bias_region([1 4],id));
c = squeeze(nanmean(out.bias_decade_rnd_annual(yrs-1849,id,:))) + squeeze(out.bias_fixed_random(:,id)) + squeeze(nanmean(out.bias_region_rnd([1 4],id,:)));

disp(['The mean offset of deck 156 measurements'])
disp(['over the NA from 1908-1912 is ',num2str(a,'%6.2f'),'C,'])
disp(['and its 2 s.d. uncertainty is ',num2str(CDC_std(c,1) * 2,'%6.2f'),'C.'])
disp([' '])
disp(['----------------------------------------------------------'])
disp([' '])

% ************************************************************
% DE Deck 192: trend
% ************************************************************
id = find(ismember(out.unique_grp,['DE',192],'rows'));
yrs = 1920:1941;
a = out.bias_decade_annual(yrs-1849,id) + out.bias_fixed(id);
b = squeeze(out.bias_decade_rnd_annual(yrs-1849,id,:)) + repmat(out.bias_fixed_random(:,id)',numel(yrs),1);
c = CDC_trend(a,1:numel(yrs),1);
d = CDC_trend(b,1:numel(yrs),1);
c{1} * numel(yrs);
CDC_std(d{1} * numel(yrs),2) * 2;


disp(['The trend in offsets of German deck 192 measurements'])
disp(['over the NA from 1920-1941 is ',num2str(c{1} * numel(yrs),'%6.2f'),'C/',num2str(numel(yrs)),' years,'])
disp(['and its 2 s.d. uncertainty is ',num2str(CDC_std(d{1} * numel(yrs),2) * 2,'%6.2f'),'C/',num2str(numel(yrs)),' years.'])
disp([' '])
disp(['----------------------------------------------------------'])
disp([' '])
