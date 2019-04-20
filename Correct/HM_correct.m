function [WM,ST,NUM] = HM_correct(varname,method,do_NpD,en,do_individual,EP)

    % *****
    % O/I *
    % *****
    if ~exist('env','var'),
        env = 1;            % 1 means on odyssey
    end

    if ~isfield(EP,'sens_id'),
        EP.sens_id = 0;
    end

    if ~isfield(EP,'connect_kobe'),
        EP.connect_kobe = 0;
    end

    if ~isfield(EP,'do_add_JP'),
        EP.do_add_JP = 0;
    end

    if ~isfield(EP,'do_rmdup'),
        EP.do_rmdup = 0;
    end

    dir_home = HM_OI('home',env);
    app = ['HM_',varname,'_',method];
    if app(end)=='_', app(end)=[]; end
    app(end+1) = '/';

    dir_load = [dir_home,app];

    if strcmp(varname,'SST'),
        dir_load_raw = [HM_OI('read_raw',env),HM_OI('SST_raw')];
    end

    % ******************************
    % Read the observational file **
    % ******************************
    file_lme = [dir_load,'Step_04_run/LME_',app(1:end-1),'_yr_start_',num2str(EP.yr_start),...
                '_deck_level_',num2str(do_NpD),'_cor_err_rmdup_',num2str(EP.do_rmdup),...
                '_rmsml_',num2str(EP.do_rmsml),'_fewer_first_',num2str(EP.do_fewer_first),...
                '_correct_kobe_',num2str(EP.do_add_JP),...
                '_connect_kobe_',num2str(EP.connect_kobe),'.mat'];

    lme = load(file_lme,'out');

    % *************************
    % Set Parameters for LME **
    % *************************
    P = HM_lme_exp_para(varname,method,EP.sens_id);

    % ******************************
    % Set Parameters for gridding **
    % ******************************
    reso_x = 5;
    reso_y = 5;
    yr_list = P.yr_list;
    yr_num = (yr_list(end)-yr_list(1))+1;

    if en == 0;
        do_individual = 0;
    end

    mon_list = 1:12;

    if en == 0 || do_individual == 1,
        do_random = 0;
    else
        do_random = 1;
    end

    % ************************************
    % Assigning effects to be corrected **
    % ************************************
    clear('E')
    E = HM_correct_assign_effect(lme,P,do_random,do_individual,en);

    % ****************************
    % Initialize the correction **
    % ****************************
    N = double(P.do_region) + double(P.do_season) + double(P.do_decade) + 3;

    clear('WM','ST','NUM')
    if en == 0 && do_individual == 0,
        WM = nan(72,36,N,12,yr_num);
        ST = nan(72,36,N,12,yr_num);
        NUM = nan(72,36,N,12,yr_num);
    else
        WM = nan(72,36,12,yr_num);
        ST = nan(72,36,12,yr_num);
        NUM = nan(72,36,12,yr_num);
    end

    % ***********************
    % Start the correction **
    % ***********************
    for yr = yr_list
        for mon = mon_list

            disp(['En :',num2str(en),' Starting Year ',num2str(yr),'  Month ',num2str(mon)])

            % ****************
            % Read in files **
            % ****************
            disp('Reading data ...')
            clear('DATA')
            DATA = HM_correct_read_data(varname,method,yr,mon,dir_load_raw,EP,env);

            % *******************************
            % Correct for deck information **
            % *******************************
            disp('Correcting for decks ...')
            clear('kind','kind_uni','J_kind')
            kind = HM_function_preprocess_deck(DATA(5:7,:)',1,EP.connect_kobe);
            if do_NpD == 0,
                kind = kind(:,1:2);
            end

            % ********************
            % Assigning Effects **
            % ********************
            disp(['Assigning effects ...'])
            clear('ID')
            if P.do_region == 1,
                ID.rid = HM_lme_effect_regional(DATA(1,:),DATA(2,:),5);
            end

            if P.do_season == 1,
                ID.sid = HM_lme_effect_seasonal(DATA(2,:),ones(size(DATA(2,:)))*mon);
            end

            if P.do_decade == 1,
                ID.did = HM_lme_effect_decadal(ones(size(DATA(2,:)))*yr,EP.yr_start,5);
            end
            clear('mx','my')

            % **********************
            % Applying Correction **
            % **********************
            disp(['Applying Correction ...'])
            clear('CORR')
            CORR = HM_correct_find_corr(DATA,E,P,ID,kind,lme.out.unique_grp);
                % The correction follows: 1. all 2.fix 3.reg 4.dcd 5.sea
                % the output is correction but not bias

            % ****************
            % Gridding data **
            % ****************
            disp(['Gridding data ...'])
            yr_id = yr-yr_list(1)+1;

            if en == 0 && do_individual == 0,

                for ct = 1:size(CORR.sst_correction,1)+1
                    if ct == 1,
                        SST_in = DATA(3,:)- DATA(4,:);
                    else
                        SST_in = nansum([DATA(3,:)- DATA(4,:); ...
                                         CORR.sst_correction(ct-1,:)],1);
                    end

                    [WM(:,:,ct,mon,yr_id),ST(:,:,ct,mon,yr_id),NUM(:,:,ct,mon,yr_id)] = ...
                    HM_function_gridding(DATA(1,:),DATA(2,:),[],SST_in,[],reso_x,reso_y,[],2,[],[],[]);
                end
            else

                SST_in = nansum([DATA(3,:)- DATA(4,:); CORR.sst_correction(1,:)],1);

                [WM(:,:,mon,yr_id),ST(:,:,yr_id),NUM(:,:,mon,yr_id)] = ...
                HM_function_gridding(DATA(1,:),DATA(2,:),[],SST_in,[],reso_x,reso_y,[],2,[],[],[]);

            end
        end
    end
end
