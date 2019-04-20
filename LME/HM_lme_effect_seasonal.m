function group_season = HM_lme_effect_seasonal(my,mon)

    lat_abs = abs(my);
    lat_abs(lat_abs<=20) = 1;
    lat_abs(lat_abs>20 & lat_abs<=40) = 2;
    lat_abs(lat_abs>40 & lat_abs<=60) = 3;
    lat_abs(lat_abs>60 & lat_abs<=90) = 4;

    season_cmp = mon;
    season_cmp(ismember(mon,[12 1 2]))  = 1;
    season_cmp(ismember(mon,[3 4 5]))   = 2;
    season_cmp(ismember(mon,[6 7 8]))   = 3;
    season_cmp(ismember(mon,[9 10 11])) = 4;

    group_season = (lat_abs-1)*4 + season_cmp;
    group_season(my<0) = (lat_abs(my<0)-1)*4 + ...
                          rem(season_cmp(my<0)+2-0.5,4)+0.5;
end
