% CDF_panel(axis_range,panel_label,legend_text,x_label_text,y_label_text,varargin)
% 
% CDF_panel sets the layout design of the panel
% 
% Customizable input argument:
%  - "barloc": location of colorbar              default: "eastoutside"
%  - "bartit": title of colorbar (name - unit)   default: ''
%  - "fontsize":                                 default: 15
%  - "fs_tit": excessive size of title           default: 3
%  - "plcol":  color of panel label              default: black
%  - "do_title": to write panel_label as title   default: 0
%
% Last update: 2018-08-13

function CDF_panel(axis_range,panel_label,legend_text,x_label_text,y_label_text,varargin)

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

    hold on;

    % *********************************************************************
    % Set legend
    % ********************************************************************* 
    if nnz(ismember(para(:,1),'legend_h')) == 0,
        h = gca;
    else
        h = para{ismember(para(:,1),'legend_h'),2};
    end    
    
    if ~isempty(legend_text),
        legend(h,legend_text,'fontsize',18,'fontweight','bold','location','best')
    end

    % *********************************************************************
    % Set axis
    % ********************************************************************* 
    if ~isempty(axis_range),
        ss = axis_range;
        plot(ss([1 2 2 1 1]),ss([3 3 4 4 3]),'k-','linewi',2);
        axis(ss);
    end
    grid on;
    xlabel(x_label_text)
    ylabel(y_label_text)
    if nnz(ismember(para(:,1),'fontsize')) == 0,
        fs = 15;
    else
        fs = para{ismember(para(:,1),'fontsize'),2};
    end
    set(gca,'fontsize',fs,'fontweight','bold');

    % *********************************************************************
    % Set colorbar
    % ********************************************************************* 

    
    if nnz(ismember(para(:,1),'bartit')) ~= 0,
        
        title_colorbar = para{ismember(para(:,1),'bartit'),2};

        if nnz(ismember(para(:,1),'barloc')) == 0,
            location = 'eastoutside';
        else
            location = para{ismember(para(:,1),'barloc'),2};
        end
        h2 = colorbar('location',location);

        if nnz(ismember(para(:,1),'bartickl')) ~= 0,

            bartickl = para{ismember(para(:,1),'bartickl'),2};

            if nnz(ismember(para(:,1),'bartick')) ~= 0,
                bartick = para{ismember(para(:,1),'bartick'),2};       
            else
                bartick = [1:1:numel(bartickl)] -0.5;
            end

            if nnz(ismember(location,{'eastoutside','east'})) > 0,
                set(h2,'ytick',bartick,'yticklabel',bartickl)
            else
                set(h2,'xtick',bartick,'xticklabel',bartickl)
            end   
            
            caxis([0 numel(bartickl)])
        end 

        if nnz(ismember(location,{'eastoutside','east'})) > 0,
            ylabel(h2,title_colorbar);
        else
            xlabel(h2,title_colorbar);
        end  

    end 

    % *********************************************************************
    % Set title or panel
    % ********************************************************************* 
    if ~isempty(panel_label),
        if nnz(ismember(para(:,1),'dotitle')) == 0,
            do_title = 0;
        else
            do_title = para{ismember(para(:,1),'dotitle'),2};
        end
        
        if nnz(ismember(para(:,1),'plcol')) == 0,
            plcol = [1 1 1] * 0;
        else
            plcol = para{ismember(para(:,1),'plcol'),2};
        end

        if nnz(ismember(para(:,1),'fstit')) == 0,
            fs_tit = 3;
        else
            fs_tit = para{ismember(para(:,1),'fstit'),2};
        end
        
        if do_title == 0,
            
            r = ss;
            h = gca;
            
            if strcmp(h.XScale,'log'),
                r([1 2]) = log(r([1 2]));
            end
            
            if strcmp(h.YScale,'log'),
                r([3 4]) = log(r([3 4]));
            end
            
            dis_x = (r(2) - r(1)) / 15;
            dis_y = (r(4) - r(3)) / 12;
            r_x = r(1) + dis_x;
            r_y = r(4) - dis_y;
            
            if strcmp(h.XScale,'log'),
                r_x = exp(r_x);
            end
            
            if strcmp(h.YScale,'log'),
                r_y = exp(r_y);
            end
            
            text(r_x,r_y,panel_label,'color',plcol,...
                'fontsize',fs + fs_tit, 'fontweight','bold');
        else
            title (panel_label,'fontsize',fs + fs_tit,'fontweight','bold');
        end
    end
    
    % *********************************************************************
    % Set figures
    % ********************************************************************* 
    set(gcf, 'PaperPositionMode','auto');
    set(gcf,'color','w');

end