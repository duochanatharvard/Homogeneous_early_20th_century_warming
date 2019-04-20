function M = HM_lme_matrix(N_pairs,N_groups,J_grp_1,J_grp_2,W_X,data_cmp,weigh_use,...
              do_region,do_season,do_decade,group_region,group_season,group_decade)

    % ************************************************
    % Prepare for the design matrix of fixed effect **
    % ************************************************
    disp('Prepare for the design matrix of fixed effect')
    M.X = HM_lme_matrix_generate(N_pairs,N_groups,J_grp_1,J_grp_2,W_X);

    % ***************************************************
    % Prepare for the design matrix of regional effect **
    % ***************************************************
    if do_region == 1,
        disp('Prepare for the design matrix of regional effect')
        N_region = max(group_region);
        N_groups_reg = N_groups * N_region;
        J_reg_1 = (J_grp_1 - 1) * N_region + group_region;
        J_reg_2 = (J_grp_2 - 1) * N_region + group_region;

        app = repmat(zeros(size(W_X)),1,N_region);
        M.Z_region = HM_lme_matrix_generate(N_pairs,N_groups_reg,J_reg_1,J_reg_2,app);
        M.logic_region = any(M.Z_region ~= 0,1);
    end

    % ***************************************************
    % Prepare for the design matrix of seasonal effect **
    % ***************************************************
    if do_season == 1,
        disp('Prepare for the design matrix of seasonal effect')
        N_season = max(group_season);
        N_groups_sea = N_groups * N_season;
        J_sea_1 = (J_grp_1 - 1) * N_season + group_season;
        J_sea_2 = (J_grp_2 - 1) * N_season + group_season;

        app = repmat(zeros(size(W_X)),1,N_season);
        M.Z_season = HM_lme_matrix_generate(N_pairs,N_groups_sea,J_sea_1,J_sea_2,app);
        M.logic_season = any(M.Z_season ~= 0,1);
    end

    % **************************************************
    % Prepare for the design matrix of decadal effect **
    % **************************************************
    if do_decade == 1,
        disp('Prepare for the design matrix of decadal effect')
        N_decade = max(group_decade);
        N_groups_dcd = N_groups * N_decade;
        J_dcd_1 = (J_grp_1 - 1) * N_decade + group_decade;
        J_dcd_2 = (J_grp_2 - 1) * N_decade + group_decade;

        app = repmat(zeros(size(W_X)),1,N_decade);
        M.Z_decade = HM_lme_matrix_generate(N_pairs,N_groups_dcd,J_dcd_1,J_dcd_2,app);
        M.logic_decade = any(M.Z_decade ~= 0,1);
    end

    % ********************************
    % Prepare for the Y and weights **
    % ********************************
    M.Y = data_cmp(:,1);
    M.Y(end + [1:size(W_X,1)]) = 0;

    M.W = weigh_use;
    M.W(end + [1:size(W_X,1)]) = 100000000;

    M.X_in = M.X;

    % *******************************************
    % Generate final matrices used for fitting **
    % *******************************************
    ct = 0;

    if do_region == 1,
        ct = ct + 1;
        M.Z_in{ct} = M.Z_region(:,M.logic_region);
        M.structure{ct} = 'Isotropic';
        M.reg_id = ct;
    end

    if do_season == 1,
        ct = ct + 1;
        M.Z_in{ct} = M.Z_season(:,M.logic_season);
        M.structure{ct} = 'Isotropic';
        M.sea_id = ct;
    end

    if do_decade == 1,
        ct = ct + 1;
        M.Z_in{ct} = M.Z_decade(:,M.logic_decade);
        M.structure{ct} = 'Isotropic';
        M.dcd_id = ct;
    end

    if do_region == 0 && do_season == 0 && do_decade == 0,
        M.do_random = 0;
    else
        M.do_random = 1;
    end
end
