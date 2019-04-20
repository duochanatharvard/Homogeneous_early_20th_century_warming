function group_region = HM_lme_effect_regional(mx,my,reso)

    if reso ~= 5,
        disp(['Though assigned resolution is: ', num2str(reso),' degrees'])
        disp('Computed resolution is fixed to 5 degrees')  
    end
    mask_region = CDF_region_mask;
    mask_region(mask_region == 0) = nan;
    group_region = HM_function_grd2pnt(mx,my,[],mask_region',5,5,[]);

end
