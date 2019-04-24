% [output,l_effect] = CDC_corr(field_1,field_2,dim)
% 
% CDC_corr computes the correlation in certain dimension
% 
% Last update: 2018-08-09

function [output,l_effect] = CDC_corr(field_1,field_2,dim)

    if  nargin == 2 && size(field_1,1) ~= 1,
        dim = 1;
    elseif nargin == 2 && size(field_1,1) == 1,
        dim = 2;    
    end

    l_nan = isnan(field_1) | isnan(field_2);
    field_1 (l_nan) = nan;
    field_2 (l_nan) = nan;
    
    field_anm_1 = CDC_demean(field_1 , dim);
    field_anm_2 = CDC_demean(field_2 , dim);
    
    l_effect = CDC_nansum( ~l_nan , dim) - 1;
    
    var_1  = CDC_nansum(field_anm_1 .* field_anm_1,dim) ./ l_effect;
    var_2  = CDC_nansum(field_anm_2 .* field_anm_2,dim) ./ l_effect;
    cov_12 = CDC_nansum(field_anm_1 .* field_anm_2,dim) ./ l_effect;
    
    output = cov_12 ./ sqrt(var_1) ./ sqrt(var_2);

end