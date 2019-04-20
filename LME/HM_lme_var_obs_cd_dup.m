function [var_rnd,var_ship,pow] = HM_lme_var_obs_cd_dup...
                            (varname,method,do_NpD)

    if strcmp(varname,'SST'),
        if strcmp(method,'Bucket'),
            if do_NpD == 0,
                var_rnd  = 1.66;   var_ship = 1.09;    pow = 0.57;
            elseif do_NpD == 1,
                var_rnd  = 1.72;   var_ship = 0.77;    pow = 0.57;
            end
        end
    end

    var_rnd = var_rnd / 2;
    var_ship = var_ship / 2;
end
