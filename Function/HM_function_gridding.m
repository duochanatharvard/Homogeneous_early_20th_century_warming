% [WM,ST,NUM] = HM_function_gridding =
%           (lon,lat,t,filed,id,rexo_x,reso_y,reso_t,mode,tname,is_w,is_un)
function [WM,ST,NUM] = HM_function_gridding(lon,lat,t,filed,id,...
                                     rexo_x,reso_y,reso_t,mode,tname,is_w,is_un)

      [var_grd,~] = HM_function_pnt2grd_3d(lon,lat,t,filed,...
                                           id,rexo_x,reso_y,reso_t,mode,tname);

      [WM,ST,NUM] = HM_function_grd_average(var_grd,is_w,is_un);
end
