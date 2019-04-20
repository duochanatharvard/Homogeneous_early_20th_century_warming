% Take the trend with missing values considered
% The output has the unit of xx per 10 time steps......
% sst_trd = HM_function_trend(sst_cor,threshold,logic_not_filled)

function sst_trd = HM_function_trend(sst_cor,threshold,logic_not_filled)

    yr_num = size(sst_cor,3);

    if ~exist('threshold','var'),
        threshold = 0.75;
    end

    if ~exist('logic_not_filled','var'),
        logic_not_filled = ~isnan(sst_cor);
    end

    if isempty(threshold), threshold = 0.75; end
    if isempty(logic_not_filled), logic_not_filled = ~isnan(sst_cor); end

    for i = 1:size(sst_cor,1)
        for  j = 1:size(sst_cor,2)

            temp = squeeze(sst_cor(i,j,:));
            temp_not_filled = squeeze(logic_not_filled(i,j,:));
            condition_1 = nnz(temp_not_filled) >= (yr_num * threshold);
            condition_2 = any(~isnan(temp(1:5)));
            condition_3 = any(~isnan(temp(end-4:end)));

            if condition_1 && condition_2 && condition_3,
                yr  = [1:yr_num]';
                one = ones(yr_num,1);
                y   = sst_cor(i,j,:);
                y   = y(:);
                logic = ~isnan(y);
                [b,bint] = regress(y(logic),[yr(logic) one(logic)]);
                sst_trd(i,j) = b(1) * 10; %yr_num;
            else
                sst_trd(i,j) = nan;
            end
        end
    end
end
