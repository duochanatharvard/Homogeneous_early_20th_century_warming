function [out,lme] = HM_lme_fit(file_load,do_sampling,target)

    % *******************
    % Input and Output **
    % *******************
    clear('BINNED')
    load(file_load);

    % **************************
    % Assign data and effects **
    % **************************
    clear('data_cmp','kind_cmp_1','kind_cmp_2','group_season',...
          'group_region','group_decade','weigh_use')
    logic = isnan(BINNED(:,1)) | isnan(BINNED(:,2));
    BINNED(logic,:) = [];
    data_cmp = double(BINNED(:,1));

    if ismember(size(BINNED,2),[11 12]),
        do_NpD = 1;
    else
        do_NpD = 0;
    end

    if do_NpD == 1,
        kind_cmp_1 = double(BINNED(:,6:8));
        kind_cmp_2 = double(BINNED(:,9:11));
    else
        kind_cmp_1 = double(BINNED(:,6:7));
        kind_cmp_2 = double(BINNED(:,8:9));
    end

    group_season = double(BINNED(:,5));
    group_region = double(BINNED(:,4));
    group_decade = double(BINNED(:,3));
    weigh_use    = double(BINNED(:,2));

    % ********************
    % Assign parameters **
    % ********************
    if all(group_season) == 0, do_season = 0; else do_season = 1; end
    if all(group_region) == 0, do_region = 0; else do_region = 1; end
    if all(group_decade) == 0, do_decade = 0; else do_decade = 1; end

    % ************************************
    % Convert grouping into numbers     **
    % kind_cmp = unique_grp(J_grp,:);   **
    % ************************************
    N_pairs = size(data_cmp,1);
    [unique_grp,~,J_grp] = unique([kind_cmp_1;kind_cmp_2],'rows');
    J_grp_1 = J_grp(1:N_pairs);
    J_grp_2 = J_grp(N_pairs+1:end);
    N_groups = size(unique_grp,1);

    % ************************************************
    % See how many subgroups to the comparison form **
    % Typically, there should be one group          **
    % ************************************************
    [JJ_grp,~,~] = unique([J_grp_1 J_grp_2],'rows');
    clusters = HM_function_find_group(JJ_grp);
    N_clusters = size(clusters,1);
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    % If N_cluster is not one, you have to re-compute the W_X matrix !!
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    % *****************************************
    % Prepare for the Design Matrices of LME **
    % *****************************************
    if target == 0,
        M = HM_lme_matrix(N_pairs,N_groups,J_grp_1,J_grp_2,W_X,data_cmp,weigh_use,...
                      do_region,do_season,do_decade,group_region,group_season,group_decade);
        M.N_decade = max(group_decade);
        M.N_region = max(group_region);
        M.N_season = max(group_season);
    end
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    % To be done, adding relative to a nation function !!
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

    % *******************************
    % Remove Non-informative Pairs **
    % *******************************
    clear('logic_non')
    logic_non(:,1) = all(M.X_in == 0,2);
    if M.do_random == 1,
        for i = 1:numel(M.Z_in)
            logic_non(:,i+1) = all(M.Z_in{i} == 0,2);
        end
    end
    logic_non = all(logic_non,2);
    disp(['Remove ',num2str(nnz(logic_non)),' non informative pairs'])

    M.X_in(logic_non,:) = [];
    M.Y(logic_non) = [];
    M.W(logic_non) = [];
    if M.do_random == 1,
        for i=1:numel(M.Z_in)
            M.Z_in{i}(logic_non,:) = [];
        end
    end

    % ************************
    % Fitting the LME model **
    % ************************
    disp('4. Fitting the LME model')
    clear('J_grp','J_grp_1','J_grp_2','J_shp',...
          'J_shp_1','J_shp_2','JJ_grp','JJ_shp')
    clear('kind_cmp_1','kind_cmp_2','data_cmp')
    clear('X','Z','Z_decade_l2','Z_decade_l1','Z_region_1',...
          'Z_region_2','Z_season_1','Z_season_2','X_l1','X_l2')
    if M.do_random == 0,
        lme = fitlmematrix(double(M.X_in),double(M.Y),[],[],...
            'FitMethod','ML','Weights',double(M.W));
    else
        lme = fitlmematrix(double(M.X_in),double(M.Y),M.Z_in,[],...
            'Covariancepattern',M.structure,'FitMethod','ML',...
            'Weights',double(M.W));
    end

    % ******************
    % Post-processing **
    % ******************
    if target == 0,
        out = HM_lme_post(M,lme,unique_grp,N_groups,do_sampling,...
                          do_region,do_season,do_decade);
    end
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
    % To be done, adding relative to a nation function !!
    % !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

end
