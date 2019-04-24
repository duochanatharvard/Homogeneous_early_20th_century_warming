% output = CDC_smooth2(M,dim,iter)
% 
% CDC_smooth2 is a matrix smoother that works for 2D and handles nan.
% It also takes into consider periodic boundary condition for longitude
% And it altilatically loop over the third dimension !!!
% 
% This script is modified from smooth2PH
% 
% SM   = smoothed output Matrix.
% M    = input Matrix.
% dim  = dimension of smoother, must be an odd number
% do_longitude = defalut is one, assuming the first dimension is longitude
% iter = self-convolutions of the smoother, 0 = boxcar.  
% 
% Last update: 2018-08-09

function output = CDC_smooth2(input,dim,do_longitude,iter)

    if ~exist('dim','var'),
        dim = 3;
    end
    
    if isempty(dim),
        dim = 3;  
    end

    if ~exist('do_longitude','var'), 
        do_longitude = 1;  
    end
    
    if ~exist('iter','var'), 
        iter = 1;  
    end

    if rem(dim,2)~=1, 
        error('smoother dimension must be odd'); 
    end;

    x = ones(dim,dim);
    for ct = 1:iter,
        x = conv2(x,x); 
    end;
    x = x / CDC_nansum(x(:));

    for ct = 1:size(input,3)
        
        clear('M','SM')
        if do_longitude == 1,
            M = [input(:,:,ct); input(:,:,ct); input(:,:,ct)];
        else
            M = input(:,:,ct);
        end
        
        MM = ones(size(M));
        MM(isnan(M)) = NaN;
        SM = CDC_conv2(x,M) ./ CDC_conv2(x,MM);
        
        output(:,:,ct) = SM;
    end
    
    n = (length(x)-1)/2;
    output = output(n+1:end-n,n+1:end-n);
    
    if do_longitude == 1,
        
        N = size(input,1);
        output = output(N+1:2*N,:);
    end
    
    output(isnan(input)) = NaN;
end