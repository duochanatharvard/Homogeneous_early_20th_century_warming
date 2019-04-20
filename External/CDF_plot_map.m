% CDF_plot_map(type,data,varargin)
% 
% External functions used:
%  - m_proj_nml
%  - CDF_m_pcolor
%  - colormap_CD
% 
% Customizable input argument:
%  - "lon":  longitude                           default: [0 : 360]
%  - "lat":  latitude                            default: [-90 : 90]
%  - "mask": only plot the region that is masked default: show all 
%  - "region": [lon_w lon_e lat_s lat_n] :       default: [0 360 -90 90]
%  - "bckgrd": Color of missing value            default: gray
%  - "barloc": location of colorbar              default: "eastoutside"
%  - "bartit": title of colorbar (name - unit)   default: ''
%  - "bartick": ticks of colorbar                defaulr: --
%  - "bartickl": labels for ticks of colorbar    defaulr: --
%  - "crange": range of colormap                 default: [min max]
%  - "cmap": colormap                            default: jet
%     -> when crange is assigned, default of cmap can be "b2r" or "hot"
%  - "cnum": number of colors                    default: 6
%  - "fontsize":                                 default: 20
%  - "docoast": Plot coast line                  default: 1
%  - "coastcol": color of coast line             default: black
%  - "coastwi":  width of coast line             default: 2
%  - "subcoast": plot subcoast                   default: 0
%  - "plabel": panel label                       default: ''
%  - "plcol":  color of panel label              default: black
%  - "scatsize": size of markers in scatter plot default: 5
%  - "scatst": style of markers in scatter plot  default: '.'
%  - "sig": significant test                     default: --
%  - "sigtype": how to plot significance         default: "marker", otherwise shading
%  - 'xtick','ytick': ticks of map
%  - "daspect"
%
% Last update: 2018-08-20
 

function CDF_plot_map(type,data,varargin)

    % *********************************************************************
    % Parse input argument
    % ********************************************************************* 
    if numel(varargin) == 1,
        varargin = varargin{1};
    end
    para = reshape(varargin(:),2,numel(varargin)/2)';
    for ct = 1 : size(para,1)
        temp = para{ct,1};
        temp = lower(temp);
        temp(temp == '_') = [];
        para{ct,1} = temp;
    end


    % *********************************************************************
    % Start up
    % *********************************************************************
    hold on;

    % *********************************************************************
    % Set up the projection
    % *********************************************************************
    if nnz(ismember(para(:,1),'region')) == 0,
        region_list = [0 360 -90 90];
    else
        region_list = para{ismember(para(:,1),'region'),2};
    end
    m_proj_nml(11,region_list([3 4 1 2]));
    r = region_list;
    
    % *********************************************************************
    % Generate grids
    % *********************************************************************
    if nnz(ismember(para(:,1),'lat')) == 0,
        reso_x = 360 / size(data,1);
        reso_y = 180 / size(data,2);
        lon = 0+reso_x/2 : reso_x : 360;
        lat = -90+reso_y/2 : reso_y : 90;
    else
        lat = para{ismember(para(:,1),'lat'),2};
        lon = para{ismember(para(:,1),'lon'),2};
    end

    [lat,lon] = meshgrid(lat,lon);

    % *********************************************************************
    % Generate colormap
    % ********************************************************************* 
    if nnz(ismember(para(:,1),'crange')) == 0,
        c_range = [min((data(:))) max((data(:)))];
        flag = 1;
    else
        c_range = para{ismember(para(:,1),'crange'),2};
        if numel(c_range) == 1;
            if min((data(:))) < 0,
                c_range = [-1 1]* c_range;
            else
                c_range = [0 1]* c_range;
            end
        end
        flag = 0;
    end
    caxis(c_range);

    if nnz(ismember(para(:,1),'cnum')) == 0,
        c_num = 6;
    else
        c_num = para{ismember(para(:,1),'cnum'),2};
    end

    if nnz(ismember(para(:,1),'cmap')) == 0,
        if flag == 1,
                colormap_CD([0.45 0.70; 0.25 0.9],[0.7 0.35],[0 0],c_num);
        else
            if min((data(:))) < 0,
                colormap_CD([0.45 0.7; 0.22  0.9],[1 0.35],[0 0],c_num);
            else
                colormap_CD([0.25  0.9],[0.99 0.35],[0 0],c_num);
            end
        end
    else
        c_map = para{ismember(para(:,1),'cmap'),2};
        colormap(gca,c_map);
    end

    % *********************************************************************
    % Plot colorbar
    % *********************************************************************
    if nnz(ismember(para(:,1),'barloc')) == 0,
        location = 'eastoutside';
    else
        location = para{ismember(para(:,1),'barloc'),2};
    end 
    h2 = colorbar('location',location);

    if nnz(ismember(para(:,1),'bartit')) == 0,
        title_colorbar = '';
    else
        title_colorbar = para{ismember(para(:,1),'bartit'),2};
    end 

    if nnz(ismember(location,{'eastoutside','east'})) > 0,
        ylabel(h2,title_colorbar)
    else
        xlabel(h2,title_colorbar)
    end
    
    if nnz(ismember(para(:,1),'bartickl')) ~= 0,
        
        bartickl = para{ismember(para(:,1),'bartickl'),2};
        
        if nnz(ismember(para(:,1),'bartick')) ~= 0,
            bartick = para{ismember(para(:,1),'bartick'),2};       
        else
            bartick = c_range(1):1:c_range(2);
        end
        
        if nnz(ismember(location,{'eastoutside','east'})) > 0,
            set(h2,'ytick',bartick,'yticklabel',bartickl)
        else
            set(h2,'xtick',bartick,'xticklabel',bartickl)
        end         
    end 

    % *********************************************************************
    % Plot Variable: Scatter
    % *********************************************************************
    if strcmp(type,'scatter'),

        % *************************************************************
        % Plot background
        % *************************************************************
        if nnz(ismember(para(:,1),'bckgrd')) == 0,
            bckgrd = [1 1 1]/2;
        else
            bckgrd = para{ismember(para(:,1),'bckgrd'),2};
        end

        if nnz(ismember(para(:,1),'scatsize')) == 0,
            scatsize = 5;
        else
            scatsize = para{ismember(para(:,1),'scatsize'),2};
        end

        if nnz(ismember(para(:,1),'scatst')) == 0,
            scatst = '.';
        else
            scatst = para{ismember(para(:,1),'scatst'),2};
        end
        
        
        m_patch([r(1)-360 r(2)+360 r(2)+360 r(1)-360],[r(3) r(3) r(4) r(4)],...
                 bckgrd,'linest','none');

        pic_x = [data(:,1)-360; data(:,1); data(:,1)+360];
        pic_y = [data(:,2); data(:,2); data(:,2)];
        pic_z = [data(:,3); data(:,3); data(:,3)];

        logic = pic_x > region_list(1) &  pic_x < region_list(2) & ... 
                pic_y > region_list(3) &  pic_y < region_list(4);

        m_scatter(pic_x(logic),pic_y(logic),scatsize,pic_z(logic),scatst);
        
    else

        % *************************************************************
        % Prepare and mask the data 
        % *************************************************************
        if nnz(ismember(para(:,1),'mask')) == 0,
            mask = ones(size(data));
        else
            mask = para{ismember(para(:,1),'mask'),2};
            if size(mask,1) ~= size(data,1),
                mask = mask';
            end
        end

        data(mask == 0) = nan;
        data = [data; data; data];
        lon = [lon-360; lon; lon+360];
        lat = [lat; lat; lat];

        % *****************************************************************
        % Pcolor
        % *****************************************************************
        if strcmp(type,'pcolor'),

            % *************************************************************
            % Plot background
            % *************************************************************
            if nnz(ismember(para(:,1),'bckgrd')) == 0,
                bckgrd = [1 1 1]/2;
            else
                bckgrd = para{ismember(para(:,1),'bckgrd'),2};
            end
            m_patch([r(1)-360 r(2)+360 r(2)+360 r(1)-360],[r(3) r(3) r(4) r(4)],...
                     bckgrd,'linest','none');

            h = CDF_m_pcolor(lon,lat,data);

        % *****************************************************************
        % Filled Contour
        % *****************************************************************
        elseif strcmp(type,'contourf'),
            
            if flag == 0,
                line_list = [-100000 -1:1/c_num:1] * c_range(2);
                m_contourf(lon,lat,data,line_list,'linest','none');
            else
                m_contourf(lon,lat,data,c_num*2,'linest','none');
            end
        end
        
        % *****************************************************************
        % Significance test
        % *****************************************************************
        if nnz(ismember(para(:,1),'sig')) ~= 0,

            pic_sig = para{ismember(para(:,1),'sig'),2};
            
            if nnz(ismember(para(:,1),'sigtype')) == 0,
                sigtype = 'marker';
            else
                sigtype = para{ismember(para(:,1),'sigtype'),2};
            end

            M = [mask; mask; mask];
            S = [pic_sig; pic_sig; pic_sig];
            lon_list = find(lon(:,1) >= r(1) & lon(:,1) <= r(2));
            lat_list = find(lat(1,:) >= r(3) & lat(1,:) <= r(4));
            
            if strcmp(sigtype,'marker'),   % Use markers to indicate significance
                reso_x = abs(mode(lon(2:end,1) - lon(1:end-1,1)));
                reso_y = abs(mode(lat(1,2:end) - lat(1,1:end-1)));
                intv = max(5 / reso_x,1); 
                for ct1 = lon_list(1:intv:end)'
                    for ct2 = lat_list(1:1:end)
                        if M(ct1,ct2) ~= 0 && S(ct1,ct2,1) ~=0,
                            % m_plot(lon(ct1,ct2),lat(ct1,ct2),'^','color','w','markersize',4,'linewi',3)
                            m_plot(lon(ct1,ct2),lat(ct1,ct2),'+','color','k','markersize',3)
                        end

                        if M(ct1,ct2) ~= 0 && S(ct1,ct2,2) ~=0,
                            % m_plot(lon(ct1,ct2),lat(ct1,ct2),'v','color','w','markersize',4,'linewi',3)
                            % m_plot(lon(ct1,ct2),lat(ct1,ct2),'v','color','k','markersize',4)
                            m_plot(lon(ct1,ct2)+[-1 1]*1.2,lat(ct1,ct2)+[-1 1]*0,'-','color','k','markersize',4)
                        end                        
                    end
                end
                
            else    % Use shading to indicate significance
                reso_x = abs(mode(lon(2:end,1) - lon(1:end-1,1)));
                reso_y = abs(mode(lat(1,2:end) - lat(1,1:end-1)));
                
                if reso_x >= 5,
                    intv = max(5 / reso_x,1); 
                    for ct1 = lon_list(1:intv:end)'
                        for ct2 = lat_list(1:intv:end)
                            if M(ct1,ct2) ~= 0 && any(S(ct1,ct2,:)),

                                m_plot(lon(ct1,ct2) + [-0.5 0.5] * reso_x * 2, ...
                                       lat(ct1,ct2) + [-0.5 0.5] * reso_y * 2,...
                                       '-','color',[.5 .5 1]*.0,'linewi',1)
                            end                      
                        end
                    end
                else
                    for ct1 = lon_list'
                        for ct2 = lat_list
                            if M(ct1,ct2) ~= 0 && any(S(ct1,ct2,:)),

                                if rem(ct1,2) == 1,
                                    lon1 = lon(ct1,ct2) + [-0.5 0.5] * reso_x;
                                else
                                    lon1 = lon(ct1,ct2) + [0.5 -0.5] * reso_x;
                                end

                                if rem(ct2,2) == 1,
                                    lat1 = lat(ct1,ct2) + [-0.5 0.5] * reso_y;
                                else
                                    lat1 = lat(ct1,ct2) + [0.5 -0.5] * reso_y;
                                end

                                m_plot(lon1,lat1,'-','color',[1 1 1]*.4,'linewi',1)
                            end
                        end
                    end
                end
            end   
        end
    end

    % *********************************************************************
    % Plot grid lines
    % *********************************************************************
    if nnz(ismember(para(:,1),'fontsize')) == 0,
        fs = 20;
    else
        fs = para{ismember(para(:,1),'fontsize'),2};
    end

    if nnz(ismember(para(:,1),'xtick')) == 0,
        x_tick = [-360:60:360];
    else
        x_tick = para{ismember(para(:,1),'xtick'),2};
    end

    if nnz(ismember(para(:,1),'ytick')) == 0,
        y_tick = [-90:30:90];
    else
        y_tick = para{ismember(para(:,1),'ytick'),2};
    end
    
    m_grid('xtick',x_tick,'ytick',y_tick,'fontsize',fs,'fontweight','bold');

    % *********************************************************************
    % Add coastlines
    % *********************************************************************
    if nnz(ismember(para(:,1),'coastcol')) == 0,
        coast_color = [1 1 1] * 0;
    else
        coast_color = para{ismember(para(:,1),'coastcol'),2};
    end
    if nnz(ismember(para(:,1),'subcoast')) == 0,
        subcoast = 0;
    else
        subcoast = para{ismember(para(:,1),'subcoast'),2};
    end
    if nnz(ismember(para(:,1),'docoast')) == 0,
        docoast = 1;
    else
        docoast = para{ismember(para(:,1),'docoast'),2};
    end
    if nnz(ismember(para(:,1),'coastwi')) == 0,
        coastwi = 2;
    else
        coastwi = para{ismember(para(:,1),'coastwi'),2};
    end

    if subcoast > 0,
        CDF_boundaries('color',coast_color,'do_m_map',1)
    end
    
    if docoast ~= 0,
        if coastwi == 1,
            m_coast('color',coast_color,'linewi',coastwi);
        else
            m_coast('color','k','linewi',coastwi);
            m_coast('color',coast_color,'linewi',1);
        end
    end

    % *********************************************************************
    % Set up the whole figure
    % *********************************************************************  
    if nnz(ismember(para(:,1),'daspect')) == 0,
        daspect([1 .7 1]);
    else
        daspect(para{ismember(para(:,1),'daspect'),2});
    end

    
    set(gcf, 'PaperPositionMode','auto');
    set(gcf,'color','w');
    set(gca,'fontsize',fs,'fontweight','bold');

    m_plot([r(1) r(2) r(2) r(1) r(1)],[r(3) r(3) r(4) r(4) r(3)],...
        'k-','linewi',2)

    % *********************************************************************
    % Add the figure label
    % ********************************************************************* 
    if nnz(ismember(para(:,1),'plabel')) == 0,
        plabel = '';
    else
        plabel = para{ismember(para(:,1),'plabel'),2};
    end

    if nnz(ismember(para(:,1),'plcol')) == 0,
        plcol = [1 1 1] * 0;
    else
        plcol = para{ismember(para(:,1),'plcol'),2};
    end

    dis = min((r(2) - r(1)) / 8 , (r(4) - r(3)) / 8);
    r_x = r(1) + dis/.7;
    r_y = r(4) - dis;


    m_text(r_x,r_y,plabel,'color',plcol,...
           'fontsize',fs + 2, 'fontweight','bold');    
end