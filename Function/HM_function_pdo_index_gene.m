function [pdo_index,pdo_index_int,pattern] = HM_function_pdo_index_gene(field,pattern,mode)

    if ~exist('mode','var'),   mode = 0; end

    % **********************************************
    % If input is monthly data, do annual average **
    % **********************************************
    if numel(size(field)) == 4,
        key = 3; key2 = 3;
        field_ann = squeeze(nanmean(field,3));
        NUM_ann = squeeze(nansum(~isnan(field),3));
        field_ann(NUM_ann < key) = nan;
        field_ann(field_ann < -key2 | field_ann > key2) = nan;
        field = field_ann;
    end

    reso_x = 360 / size(field,1);
    reso_y = 180 / size(field,2);
    lon = reso_x/2 : reso_x : 360;
    lat = (-90 + reso_y/2) : reso_y : 90;

    % ***************************
    % Only show the PDO region **
    % ***************************
    mask = CDF_land_mask(reso_x,2,reso_y,0)';
    pattern(mask) = nan;
    pattern(lon < 110 | lon > 260,:) = nan;
    pattern(:,lat < 20 | lat > 60) = nan;

    % ********************************************************
    % Nomalize the pattern to have zero mean and one spread **
    % ********************************************************
    if mode == 1,
        pattern = pattern./nansum(abs(pattern(:)));
    else
        pattern = pattern - nanmean(pattern(:));
        amplitude = max(pattern(:)) - min(pattern(:));
        pattern = pattern / amplitude;
    end

    % *************************************
    % Compute PDO index using regression **
    % *************************************
    clear('pdo_index')
    for i = 1:size(field,3)
        temp = field(:,:,i);
        temp(isnan(pattern)) = nan;
        y = temp(:);
        x = pattern(:);
        logic = ~isnan(y) & ~isnan(x);
        y = y(logic);
        x = x(logic);
        if mode == 1,
            y = y - nanmean(y);
            pdo_index(i) = nansum(x.*y)./nansum(abs(x));
            pdo_index_int = [];
        else
            [b, b_int] = regress(y(:),[x(:) ones(size(x(:)))]);
            pdo_index(i) = b(1);
            pdo_index_int(i,1:2) = b_int(1,:);
        end
    end
end
