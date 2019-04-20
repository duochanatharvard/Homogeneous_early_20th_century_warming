% Another infill function that take value from sorrounding grids
% output = HM_function_infill(input,input_num)

function output = HM_function_infill(input,input_num,no_land)

    output = input;
    if ~exist('no_land','var'), no_land = 1; end

    near_1 = nan([size(input),4]);
    near_1(:,:,:,1) = input([2:end 1],:,:);
    near_1(:,:,:,2) = input([end 1:end-1],:,:);
    near_1(:,1:end-1,:,3) = input(:,[2:end],:);
    near_1(:,2:end,:,4) = input(:,[1:end-1],:);

    num_near_1 = nan([size(input_num),4]);
    num_near_1(:,:,:,1) = input_num([2:end 1],:,:);
    num_near_1(:,:,:,2) = input_num([end 1:end-1],:,:);
    num_near_1(:,1:end-1,:,3) = input_num(:,[2:end],:);
    num_near_1(:,2:end,:,4) = input_num(:,[1:end-1],:);

    near_1_mean = nansum(near_1.*num_near_1,4) ./ nansum(num_near_1,4);

    near_2 = nan([size(input),6]);
    near_2(:,:,:,1) = input([3:end 1:2],:,:);
    near_2(:,:,:,2) = input([end-1:end 1:end-2],:,:);
    near_2(:,1:end-1,:,3) = input([2:end 1],[2:end],:);
    near_2(:,1:end-1,:,4) = input([end 1:end-1],[2:end],:);
    near_2(:,2:end,:,5) = input([2:end 1],[1:end-1],:);
    near_2(:,2:end,:,6) = input([end 1:end-1],[1:end-1],:);

    num_near_2 = nan([size(input_num),6]);
    num_near_2(:,:,:,1) = input_num([3:end 1:2],:,:);
    num_near_2(:,:,:,2) = input_num([end-1:end 1:end-2],:,:);
    num_near_2(:,1:end-1,:,3) = input_num([2:end 1],[2:end],:);
    num_near_2(:,1:end-1,:,4) = input_num([end 1:end-1],[2:end],:);
    num_near_2(:,2:end,:,5) = input_num([2:end 1],[1:end-1],:);
    num_near_2(:,2:end,:,6) = input_num([end 1:end-1],[1:end-1],:);

    near_2_mean = nansum(near_2.*num_near_2,4) ./ nansum(num_near_2,4);

    output(isnan(output)) = near_1_mean(isnan(output));
    output(isnan(output)) = near_2_mean(isnan(output));

    [~,topo,~] = CDF_land_mask(360/size(input,1),1,180/size(input,2));
    mask_land = topo' > 20;

    if no_land == 1,
        output(repmat(mask_land,1,1,size(input,3))) = nan;
    end
end
