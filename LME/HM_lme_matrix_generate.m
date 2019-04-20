function M = HM_lme_matrix_generate(N_pairs,N_groups,J_grp_1,J_grp_2,W_X,pos_val,neg_val)

    if ~exist('W_X','var'),
        W_X = zeros(1,N_groups);
    end

    if ~exist('pos_val','var'),
        pos_val = 1;
        neg_val = -1;
    end

    M = sparse(N_pairs,N_groups);

    index_pos = sub2ind([N_pairs,N_groups],[1:N_pairs]',J_grp_1);
    index_neg = sub2ind([N_pairs,N_groups],[1:N_pairs]',J_grp_2);

    logic = index_pos == index_neg;
    index_pos(logic) = [];
    index_neg(logic) = [];

    M(index_pos) = pos_val;
    M(index_neg) = neg_val;
    M = [M; W_X];

    clear('index_pos','index_neg','logic');
end
