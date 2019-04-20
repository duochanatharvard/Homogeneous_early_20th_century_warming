% [out,out_std,out_num] = HM_function_mask_average(IN_VAR,lat,mask,un)
% This function compute the regional averaged value of certain map
% A regional averaged uncertainty estimate as well as number of samples
% should be included ...
function [out,out_std,out_num] = HM_function_mask_average(IN_VAR,lat,mask,un)

    if  nargin < 4
        un_on = 0;
    else
        un_on = 1;
    end

    size_temp = size(IN_VAR);

    if(min(size(lat)) == 1)
        lat = repmat(reshape(lat,1,numel(lat)),size(IN_VAR,1),1);
    end

    weigh = cos(lat*pi/180);

    WEIGH = repmat(weigh,[1 1 size_temp(3:end)]);
    MASK  = repmat(mask ,[1 1 size_temp(3:end)]);

    if un_on,
        weigh_2 = (1 ./ (real(un) + 1));
        WEI     = MASK .* WEIGH .* weigh_2;
        IN      = IN_VAR .* WEIGH .* weigh_2;
    else
        WEI   = MASK .* WEIGH;
        IN    = IN_VAR .* WEIGH;
    end

    IN(MASK == 0) = NaN;
    WEI(isnan(IN)) = 0;

    out = nansum(nansum(IN,1),2)./nansum(nansum(WEI,1),2);

    if un_on,
        un(isnan(IN)) = NaN;
        out_std = squeeze(sqrt( nansum(nansum(un.^2 .* WEI.^2 ,1),2) ./ (nansum(nansum(WEI ,1),2).^2)));
    else
        clim = repmat(out,[size_temp(1:2) ones(1,size(size_temp,2)-2)]);
        out_std = squeeze(sqrt( nansum(nansum((IN - clim).^2 .* WEI ,1),2) ./...
            (nansum(nansum(WEI ,1),2) - nansum(nansum(WEI.^2 ,1),2)./nansum(nansum(WEI ,1),2))  ));
    end

    out = squeeze(out);
    out_num = squeeze(nansum(nansum(isnan(IN)==0,1),2));

end
