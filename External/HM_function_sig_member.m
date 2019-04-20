% Estimate significance from ensemble members, and only used in figures
function sig = HM_function_sig_member(ensemble,raw,alpha)

    if ~exist('raw','var'), raw = nanmean(ensemble,3); end
    if isempty(raw),        raw = nanmean(ensemble,3); end

    up  = quantile(ensemble,1-alpha/2,3);
    low = quantile(ensemble,alpha/2,3);
    num = nansum(~isnan(ensemble),3);
    up(num<=10)  = nan;
    low(num<=10) = nan;

    pos = low > 0 & raw > 0;
    nag = up < 0 & raw < 0;

    sig = double(pos) - double(nag);
    sig(isnan(up)) = nan;

end
