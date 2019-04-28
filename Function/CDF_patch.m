% CDF_patch(x,y,col,a)
function h = CDF_patch(x,y,col,a)

    if nargin<4
        a = 0.05;
    end
    
    s = CDC_std(y,1);
    up = nanmean(y,1) + s * abs(norminv(a/2));
    low = nanmean(y,1) - s * abs(norminv(a/2));
    
    logic = ~isnan(up);
    x = x(logic);
    up = up(logic);
    low = low(logic);
    
    h = patch([x fliplr(x)],[up fliplr(low)],col);
    alpha(h,0.6)
    set(h,'linest','none')

end