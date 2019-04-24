% CDF_bar_stack(x,y,col) --------------------------------------------------
function CDF_bar_stack(x,y,col)

    if size(y,1) ~= size(col,1) && ~isempty(col),
        error('Color and the data does not match!')
    end
    
    if isempty(col)
        col = distinguishable_colors(size(y,1));
    end
    
    pic_t = x;
    pic = y;
        
    pic_pos  = pic;
    pic_pos(pic_pos<0) = 0;
    pic_pos  = cumsum(pic_pos,1);
    pic_nag  = pic;
    pic_nag(pic_nag>0) = 0;
    pic_nag  = cumsum(pic_nag,1);
        
    for i = (size(pic,1)):-1:1
        hold on;
        bar(pic_t,pic_pos(i,:),'facecolor',col(i,:),'linest','none','barwidth',1);
        bar(pic_t,pic_nag(i,:),'facecolor',col(i,:),'linest','none','barwidth',1);
    end
    
    if 0,  % These are for debug
        figure; hold on;
        for i = 1:size(pic,1)
            plot(x,pic(i,:)+i,'color',col(i,:));
            plot(x,pic(i,:)*0+i,'color',[1 1 1]*.7);
        end
    end
        
end