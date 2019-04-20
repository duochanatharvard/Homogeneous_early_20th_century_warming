dir = '/Volumes/My Passport Pro/Hvd_SST/HM_SST_Bucket/';
stats = load([dir,'Stats_HM_SST_Bucket_deck_level_1_monthly.mat']);
lme = load([dir,'Step_04_run/LME_HM_SST_Bucket_yr_start_1850_deck_level_1',...
      '_cor_err_rmdup_0_rmsml_0_fewer_first_0_correct_kobe_0_connect_kobe_1.mat'],'out')
for i =  1:5
    lme.out.bias_decade_annual(i:5:165,:) = lme.out.bias_decade;
    lme.out.bias_decade_rnd_annual(i:5:165,:,:) = lme.out.bias_decade_rnd;
end

% Number of all records
for i = 1:165
    total(:,:,:,i) = nansum(stats.Stats_map_month(:,:,:,i,:),5);
end

mask_region = CDF_region_mask;
mask_region(mask_region == 0) = nan;
mask_region = mask_region';

id  = 154;

clear('Save_ts')
for rnd = 1:1000
    if rem(rnd,50) == 0; disp(num2str(rnd)); end
    clear('a','b','c')
    a = lme.out.bias_region_rnd(:,id,rnd);
    offset_region = zeros(72,36);
    for i = 1:17
        offset_region(mask_region == i) = a(i);
    end

    a = repmat(offset_region,1,1,12,165);
    b = lme.out.bias_decade_rnd_annual(:,id,rnd);
    b(isnan(b)) = 0;
    b = repmat(reshape(b,1,1,1,165),72,36,12,1);
    c = lme.out.bias_fixed_random(rnd,id);

    corr_full = - (a + b + c);
    if id > 100,
        ratio = stats.Stats_map_month(:,:,:,[1908:1941]-1849,id+2) ./ total(:,:,:,[1908:1941]-1849);
    else
        ratio = stats.Stats_map_month(:,:,:,[1908:1941]-1849,id) ./ total(:,:,:,[1908:1941]-1849);
    end
    corr  = corr_full(:,:,:,[1908:1941]-1849) .* ratio;

    MASK = HM_function_mask_JP_NA;
    [TS,~,~] = HM_function_mask_average(corr,[-87.5:5:87.5],MASK == 2);
    Save_ts(rnd,:) = nanmean(TS,1);
end
