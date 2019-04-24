% out = CDF_layout(panel_size,layout)
% layout: up down left right 
function out = CDF_layout(panel_size,layout)

    for i = 1:numel(layout)
        a = zeros(panel_size(1),panel_size(2));
        lt = layout{i};
        a(lt(1):lt(2),lt(3):lt(4)) = 1;
        a = a';
        out{i} = find(a == 1);
    end

end
