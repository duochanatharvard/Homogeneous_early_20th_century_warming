function [col_out,unique_grp] = HM_Fig_1_color_scheme(varname,method,do_NpD,key,env,EP)

    dir_home = HM_OI('home',env);
    app = ['HM_',varname,'_',method];
    if app(end)=='_', app(end)=[]; end
    app2 = [app, '/'];
    app = [app, '/'];
    dir_stats = [dir_home,app2];
    file_stats = [dir_stats,'Stats_',app(1:end-1),...
                  '_deck_level_',num2str(do_NpD),'.mat'];
    load(file_stats,'Stats_glb','unique_grp');

    if EP.connect_kobe == 1,
        llll = find(ismember(unique_grp,['JP',118;'JP' 119;'JP' 762],'rows'));
        Stats_glb(:,:,llll(1)) = nansum(Stats_glb(:,:,llll),3);
        Stats_glb(:,:,llll(2:end)) = [];
        unique_grp(llll(2:end),:) = [];
    end

    % Pickout decks that only exist during 1908-1941
    Stats_ann = squeeze(nansum(Stats_glb,2))';
    if EP.do_focus == 1,
        if strcmp(varname,'SST'),
            l_contribute = any(Stats_ann(:,[1908:1941]-1849) > 20 , 2);
        else
            l_contribute = any(Stats_ann(:,[1908:1941]-1899) > 20 , 2);
        end
        logic_pic = nansum(Stats_ann,2) > key & l_contribute;
    else
        logic_pic = nansum(Stats_ann,2) > key;
    end

    nat_list = {'GB','US','DE','NL','JP','RU'};
    mark = zeros(1,size(unique_grp,1));
    for nat = 1:numel(nat_list)
        l = ismember(unique_grp(:,1:2),nat_list{nat},'rows') & logic_pic;
        ct(nat) = nnz(l);
        mark(l) = 1;
    end
    ct(7) = nnz(mark' == 0 & logic_pic & unique_grp(:,1)<100);
    ct(8) = nnz(mark' == 0 & logic_pic & unique_grp(:,1)>100);

    % *******************************
    % Prepare for the color scheme **
    % *******************************
    clear('col')
    col{1} = [colormap_CD([0.00 0.02],[.7 .4],[0 0],ceil(ct(1)/2));...
              colormap_CD([0.95 0.97],[.7 .4],[0 0],ceil(ct(1)/2))];
    col{2} = [colormap_CD([0.40 0.42],[.4 .8],[0 0],ceil(ct(2)/2));...
              colormap_CD([0.50 0.47],[.4 .7],[0 0],ceil(ct(2)/2))];
    col{3} = [colormap_CD([0.67 0.67],[.5 .8],[0 0],ceil(ct(3)));];
             % colormap_CD([0.62 0.62],[.3 .7],[0 0],ceil(ct(3)/2))];
    col{4} = [colormap_CD([0.07 0.09],[0.65 0.5],[0 0],ct(4))];
    col{5} = [colormap_CD([0.15 0.15],[.7 .5],[0 0],ct(5))];
    col{6} = [colormap_CD([0.84 0.88],[.46 .8],[0 0],ct(6))];
    col{7} = [colormap_CD([0.28 0.33],[.3 .6],[0 0],ct(7))];
    col{8} = [colormap_CD([0.70 0.72],[.95 .65],[1 1],ct(8))];

    hue = [0.00 0.38 0.66 0.06 0.12 0.55 0.76];
    sat = ones(1,7) * 0.8;
    brt = ones(1,7) * 0.4;
    col_not_show = CDF_generate_RGB([hue' sat' brt'],1);
    col_not_show(8,:) = [.3 .3 .3];

    % ***************************
    % Prepare for the colormap **
    % ***************************
    col_out = nan(size(unique_grp,1),3);
    mark = zeros(1,size(unique_grp,1));
    for nat = 1:numel(nat_list)
        l = ismember(unique_grp(:,1:2),nat_list{nat},'rows') & logic_pic;
        col_out(l,:) = col{nat}(1:nnz(l),:);
        mark(l) = 1;
        l = ismember(unique_grp(:,1:2),nat_list{nat},'rows') & ~logic_pic;
        col_out(l,:) = repmat(col_not_show(nat,:),nnz(l),1);
        mark(l) = 1;
    end
    l = mark' == 0 & logic_pic & unique_grp(:,1)<100;
    col_out(l,:) = col{7}(1:nnz(l),:);
    l = mark' == 0 & ~logic_pic & unique_grp(:,1)<100;
    col_out(l,:) = repmat(col_not_show(7,:),nnz(l),1);
    l = mark' == 0 & logic_pic & unique_grp(:,1)>100;
    col_out(l,:) = col{8}(1:nnz(l),:);
    l = mark' == 0 & ~logic_pic & unique_grp(:,1)>100;
    col_out(l,:) = repmat(col_not_show(8,:),nnz(l),1);

end


% [output] = CDF_generate_RGB(input,mode)
% Generate RGB of a color given the hue, saturation, and brightness
% Hue: 0-1
% saturation: 0-1
% Brightness: 0-1 
% Mode 1: origional   Mode 2: grayness rather than brightness

function [output] = CDF_generate_RGB(Input,mode)

    if  nargin < 2
        mode = 1;
    end
    
    zzz = size(Input);
    if zzz(2) ~= 3,
        input = reshape(Input,zzz(1)*zzz(2),3);
    else
        input = Input;
    end
    clear('Input')

    Hue_temp = input(:,1);
    Str_temp = input(:,2);
    Brt_temp = input(:,3);

    Hue_temp = rem(Hue_temp + 1000,1);
    Hue_RGB = nan(size(input));

    if mode == 1;
        Brt_RGB = nan(size(input));
    else
        Gry_RGB = nan(size(input));
    end

    logic = Hue_temp>=0 & Hue_temp<1/6;
    Hue_RGB(logic,:)=repmat([1 0 0],nnz(logic),1) + repmat((Hue_temp(logic,:) - 0/6),1,3) .* 6 .* repmat([0 1 0],nnz(logic),1);

    logic = Hue_temp>=1/6 & Hue_temp<2/6;
    Hue_RGB(logic,:)=repmat([1 1 0],nnz(logic),1) - repmat((Hue_temp(logic,:) - 1/6),1,3) .* 6 .* repmat([1 0 0],nnz(logic),1);

    logic = Hue_temp>=2/6 & Hue_temp<3/6;
    Hue_RGB(logic,:)=repmat([0 1 0],nnz(logic),1) + repmat((Hue_temp(logic,:) - 2/6),1,3) .* 6 .* repmat([0 0 1],nnz(logic),1);

    logic = Hue_temp>=3/6 & Hue_temp<4/6;
    Hue_RGB(logic,:)=repmat([0 1 1],nnz(logic),1) - repmat((Hue_temp(logic,:) - 3/6),1,3) .* 6 .* repmat([0 1 0],nnz(logic),1);

    logic = Hue_temp>=4/6 & Hue_temp<5/6;
    Hue_RGB(logic,:)=repmat([0 0 1],nnz(logic),1) + repmat((Hue_temp(logic,:) - 4/6),1,3) .* 6 .* repmat([1 0 0],nnz(logic),1);

    logic = Hue_temp>=5/6 & Hue_temp<=6/6;
    Hue_RGB(logic,:)=repmat([1 0 1],nnz(logic),1) - repmat((Hue_temp(logic,:) - 5/6),1,3) .* 6 .* repmat([0 0 1],nnz(logic),1);

    Str_RGB = (Hue_RGB - .5) .* repmat(Str_temp,1,3) + .5;
    
    if(mode == 1)
        
        logic = Brt_temp > 0.5;
        Brt_RGB(logic,:) = Str_RGB(logic,:) + (1 - Str_RGB(logic,:)) .* repmat(((Brt_temp(logic,:)-0.5)./0.5),1,3);
        
        logic = Brt_temp <= 0.5;
        Brt_RGB(logic,:) = Str_RGB(logic,:) - (Str_RGB(logic,:)) .* repmat(((0.5 - Brt_temp(logic,:))./0.5),1,3);
        
        output = Brt_RGB;
        
    else
    
        Gry_temp = Brt_temp;
        
        xishu1 = 0.2989;
        xishu2 = 0.5870;
        xishu3 = 0.1140;
        
        Gry_input = sqrt(xishu1 * Str_RGB(:,1) + xishu2 * Str_RGB(:,2) + xishu3 * Str_RGB(:,3));
        
        logic = Gry_input > Gry_temp;
        
        Gry_insuf = Gry_input(logic);
        Gry_RGB(logic,:) = Str_RGB(logic,:) .* repmat(Gry_temp(logic)./Gry_insuf,1,3);
        
        logic = Gry_input < Gry_temp;
        Gry_insuf = Gry_input(logic);
        kk = repmat((Gry_temp(logic)-1)./(Gry_insuf-1),1,3);
        Gry_RGB(logic,:) = (Str_RGB(logic,:)-1).*kk + 1;
        
        logic = Gry_input == Gry_temp;
        Gry_RGB(logic,:) = Str_RGB(logic,:);

        output = Gry_RGB;
    end
    
    if zzz(2) ~= 3,
        output = reshape(output,zzz(1),zzz(2),3);
    end
    
    output(output>1) = 1;
    output(output<0) = 0;
end