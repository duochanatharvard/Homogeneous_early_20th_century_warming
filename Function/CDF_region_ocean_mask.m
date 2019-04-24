% [region_mask_out,region_name_out,mask_region] = CDF_region_ocean_mask(reso,mode)
function [region_mask_out,region_name_out,mask_region] = CDF_region_ocean_mask(reso,mode)

    if ~exist('mode','var'),
        mode = 1;
    end

    region_list = [...
        260   360    20    40
        110   180    20    40
        180   260    20    40
        260    20    40    60
        120   240    40    60
        0      40    20    50
        270    20   -20    20
        110   160   -20    20
        160   220   -20    20
        220   290   -20    20
        35    110   -20    30
        300    20   -40   -20
        20    140   -40   -20
        140   300   -40   -20
        0     360   -60   -40
        0     360   -90   -60
        0     360    60    90
        ];
    clear('mask_region')
    mask_region = nan(72,36);
    for i = 1:size(region_list,1)
        if region_list(i,1) <= region_list(i,2),
            mask_region([(region_list(i,1)+5):5:region_list(i,2)]/5,[(region_list(i,3)+95):5:region_list(i,4)+90]/5) = i;
        else
            mask_region([(region_list(i,1)+5):5:360]/5,[(region_list(i,3)+95):5:region_list(i,4)+90]/5) = i;
            mask_region([5:5:region_list(i,2)]/5,[(region_list(i,3)+95):5:region_list(i,4)+90]/5) = i;
        end
    end

    mask_region(55:58,21:22) = 7;
    mask_region = mask_region';

    clear('region_mask')
    for i = 1:17
        region_mask(:,:,i) = double(mask_region == i);
    end
    
    if mode == 2, % in mode 2, large ocean basin average
        region_mask_temp(:,:,1) = nansum(region_mask(:,:,[1 4]),3);
        region_mask_temp(:,:,2) = nansum(region_mask(:,:,[2 3 5]),3);
        region_mask_temp(:,:,3) = nansum(region_mask(:,:,[7]),3);
        region_mask_temp(:,:,4) = nansum(region_mask(:,:,[8 9 10]),3);
        region_mask_temp(:,:,5) = nansum(region_mask(:,:,[11]),3);
        region_mask_temp(:,:,6) = nansum(region_mask(:,:,[1 4 7 12]),3);
        region_mask_temp(:,:,7) = nansum(region_mask(:,:,[2 3 5 8 9 10 14]),3);
        region_mask_temp(:,:,8) = nansum(region_mask(:,:,[11 13]),3);
        region_mask = region_mask_temp;

        temp = region_mask_temp(:,:,6);
        temp([9:12 31:34],[1:4 60:72]) = 1;
        region_mask_temp(:,:,6) = temp;

        temp = region_mask_temp(:,:,7);
        temp([9:12 ],[29:58]) = 1;
        temp([31:32],[28:46]) = 1;
        region_mask_temp(:,:,7) = temp;

        temp = region_mask_temp(:,:,8);
        temp([9:12],[5:28]) = 1;
        region_mask_temp(:,:,8) = temp;
        
        region_mask = region_mask_temp;
    end

    [land_mask_temp,~] = CDF_land_mask(1,2,[],-20);
    for i = 1:36
        for j = 1:72
            land_mask(i,j) = all(all(land_mask_temp(i*5-4:i*5,j*5-4:j*5) == 1));
        end
    end
    
    [lon1,lat1] = meshgrid(reso/2:reso:360,-90+reso/2:reso:90);
    [lon0,lat0] = meshgrid(2.5:5:360,-87.5:5:90);
    
    for i = 1:size(region_mask,3)
        temp = interp2([lon0-360 lon0 lon0+360],[lat0 lat0 lat0],[region_mask(:,:,i) region_mask(:,:,i) region_mask(:,:,i)],lon1,lat1,'linear');
        region_mask_out(:,:,i) = (land_mask == 0 & temp > 0)';
    end
    
    if mode ~= 2,
        region_name = {'SubNA ','SubNWP','SubNEP','ExNA  ','ExNP  ','Mid   ','TA    ',...
            'TWP   ','TCP   ','TEP   ','TIO   ','SA    ','SIO   ','SP    ','SO    ','Ant   ','Arc   '};
    else
        region_name = {'NA ','NP ','TA ','TP ','TIO','Pac','Atl','Ind'};
    end
    
    for i = 1:numel(region_name)
        region_name_out(i,:) = region_name{i}; 
    end
    
    mask_region(land_mask == 1) = 0;

end
