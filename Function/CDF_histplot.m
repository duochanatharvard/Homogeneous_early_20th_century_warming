% histplot(x,y,st,col,lw)
function CDF_histplot(x,y,st,col,lw)

    x = x(:)';
    y = y(:)';
    
    dx = diff(x);
    xx = (x(1:end-1) + x(2:end))/2;
    xx = [xx;xx];
    xx = [x(1)-dx(1)/2 xx(:)' x(end)+dx(end)/2];
    
    yy = [y;y];
    yy = yy(:);
    
    plot(xx,yy,st,'color',col,'linewi',lw);
end