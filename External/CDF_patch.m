% CDF_patch(x,y,col,a)
function h = CDF_patch(x,y,col,a)

    if nargin<4
        a = 0.05;
    end
    
    for i = 1:size(y,2)
        up(i) = quantile(y(:,i),1-a/2);
        low(i) = quantile(y(:,i),a/2);
    end
    
    logic = ~isnan(up);
    x = x(logic);
    up = up(logic);
    low = low(logic);
    
    h = patch([x fliplr(x)],[up fliplr(low)],col);
    alpha(h,0.6)
    set(h,'linest','none')

end