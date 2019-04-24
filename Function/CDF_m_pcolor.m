% [h] = CDF_m_pcolor(long,lat,data,varargin)
% 
% This function is modifed from m_pcolor by adding +1 corrections
% 
% Last update: 2018-08-11

%  M_PCOLOR Makes a pcolor image on a map.
%    M_PCOLOR(LONG,LAT,DATA,...) is a pseudocolor  plot of matrix DATA.
%    The values of the elements of DATA specify the color in each
%    cell of the plot. In the default shading mode, 'faceted',
%    each cell has a constant color and the last row and column of
%    DATA are not used. With shading('interp'), each cell has color
%    resulting from bilinear interpolation of the color at its 
%    four vertices and all elements of DATA are used. 
%    The smallest and largest elements of DATA are assigned the first and
%    last colors given in the color table; colors for the remainder of the 
%    elements in DATA are determined by table-lookup within the remainder of 
%    the color table.
%
%    See also M_CONTOUR, CONTOURF, PCOLOR

% Rich Pawlowicz (rich@ocgy.ubc.ca) 17/Jan/1998
%
% This software is provided "as is" without warranty of any kind. But
% it's mine, so you can't sell it.

% 19/02/98 - type - should have been 'clip','patch', rather than 'off'.
%  9/12/98 - handle all-NaN plots without letting contour crash.
% 6/Nov/00 - eliminate returned stuff if ';' neglected (thx to D Byrne)

function [h] = CDF_m_pcolor(long,lat,data,varargin)

    global MAP_PROJECTION 

    % Have to have initialized a map first

    if isempty(MAP_PROJECTION),
        disp('No Map Projection initialized - call M_PROJ first!');
        return;
    end;

    if min(size(long)) == 1 && min(size(lat)) == 1,
       [lat,long] = meshgrid(lat,long);
    end;

    [X,Y]=m_ll2xy(long,lat,'clip','on');  %First find the points outside

    i=isnan(X);      % For these we set the *data* to NaN...
    data(i)=NaN;

                     % And then recompute positions without clipping. THis
                     % is necessary otherwise contouring fails (X/Y with NaN
                     % is a no-no. Note that this only clips properly down
                     % columns of long/lat - not across rows. In general this
                     % means patches may nto line up properly a right/left edges.
    if any(i(:)), [X,Y] = m_ll2xy(long,lat,'clip','patch'); end;  

    if any(~i(:)),

        X = [1.5*X(1,:)-0.5*X(2,:); (X(2:end,:)+ X(1:end-1,:))/2;...
            1.5*X(end,:)-0.5*X(end-1,:)];

        Y = [1.5*Y(1,:)-0.5*Y(2,:); (Y(2:end,:)+ Y(1:end-1,:))/2;...
            1.5*Y(end,:)-0.5*Y(end-1,:)];

        pic_x = [1.5*X(:,1)-0.5*X(:,2), (X(:,2:end)+ X(:,1:end-1))/2,...
            1.5*X(:,end)-0.5*X(:,end-1)];

        pic_y = [1.5*Y(:,1)-0.5*Y(:,2), (Y(:,2:end)+ Y(:,1:end-1))/2,...
            1.5*Y(:,end)-0.5*Y(:,end-1)];

        pic_z = [data data(:,end); data(end,:) 0];

        [h]=pcolor(pic_x,pic_y,pic_z,varargin{:});
        set(h,'tag','m_pcolor');
        set(h,'linest','none');
    else
        h=[];
    end;

    if nargout==0,
       clear  h
    end;

end