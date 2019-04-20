% Result of this script is provided as "Stats_HM_SST_Bucket_deck_level_1.mat"

HM_load_package;

varname = 'SST';
method = 'Bucket';
do_NpD = 1;

% *****************
% Set parameters **
% *****************
 do_NpD = 1;
 EP.do_rmdup = 0;
 EP.do_rmsml = 0;
 EP.sens_id  = 0;
 EP.do_fewer_first = 0;
 EP.connect_kobe   = 0;
 EP.do_add_JP = 0;
 EP.yr_start = 1850;

% *****
% O/I *
% *****
if ~exist('env','var'),
    env = 1;            % 1 means on odyssey
end

dir_home = HM_OI('home',env);
app = ['HM_',varname,'_',method];
if app(end)=='_', app(end)=[]; end
app(end+1) = '/';

dir_load = [dir_home,app];
file_save = [dir_load,'Stats_',app(1:end-1),'_deck_level_',num2str(do_NpD),'.mat'];
dir_load_raw = [HM_OI('read_raw',env),HM_OI('SST_raw')];

% ******************************
% Read the observational file **
% ******************************
file_lme = [dir_load,'Step_04_run/LME_',app(1:end-1),'_yr_start_1850',...
                     '_deck_level_',num2str(do_NpD),'_cor_err_rmdup_0',...
                     '_rmsml_0_fewer_first_0_correct_kobe_0_connect_kobe_0.mat'];

lme = load(file_lme);
kind_ref = lme.out.unique_grp;
clear('lme');

% *****************
% Set Parameters **
% *****************
P = HM_lme_exp_para(varname,method,EP.sens_id);
reso_x = 5;
reso_y = 5;
yr_list = P.yr_list;
mon_list = 1:12;

% ***********************
% Start the statistics **
% ***********************
Stats_map = zeros(360/reso_x, 180/reso_y, yr_list(end)-yr_list(1)+1, size(kind_ref,1));
Stats_glb = zeros((yr_list(end)-yr_list(1)+1),12,size(kind_ref,1));

Ratio = [];
for yr = yr_list

    disp(['Starting Year ',num2str(yr)])
    yr_id = yr-yr_list(1)+1;

    % ****************
    % Read in files **
    % ****************
    disp('Reading data ...')
    DATA = [];
    for mon = mon_list
        [DATA_temp,ratio] = HM_correct_read_data(varname,method,yr,mon,dir_load_raw,EP);
        DATA_temp(end+1,:) = mon;
        DATA = [DATA DATA_temp];
        Ratio = [Ratio ratio(:)];
    end

    % *******************************
    % Correct for deck information **
    % *******************************
    disp('Correcting for decks ...')
    clear('kind','kind_uni','J_kind')
    kind = HM_function_preprocess_deck(DATA(5:7,:)',1);
    if do_NpD == 0,
        kind = kind(:,1:2);
    end

    % ****************
    % STATISTICS!!! **
    % ****************
    disp('Do Statistics ...')
    [kind_uni,~,J_kind] = unique(kind,'rows');
    for i = 1:size(kind_uni)
        [~,dck_id] = ismember(kind_uni(i,:),kind_ref,'rows');

        if nnz(dck_id),

            % ------------------------
            % Stats for annually map |
            % ------------------------
            temp  = DATA([1,2,end],J_kind == i);
            count = hist2d(temp(1:2,:)', [0,reso_x,360; -90,reso_y,90]);
            Stats_map(:,:,yr_id,dck_id) = count;

            % --------------------------
            % Stats for monthly global |
            % --------------------------
            for mon = 1:12
                Stats_glb(yr_id,mon,dck_id) = nnz(temp(end,:) == mon);
            end
        end
    end

    Stats_total(yr_id) = size(kind,1);
end

unique_grp = kind_ref;
save(file_save,'Stats_map','Stats_glb','unique_grp','Ratio','-v7.3')
