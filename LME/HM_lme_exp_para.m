function P = HM_lme_exp_para(varname,method,sens_id)

    if ~exist('sens_id','var'),   % 1 means not sensitivity test
        sens_id = 0;
    end

    if strcmp(varname,'SST') & strcmp(method,'Bucket'),
        P.yr_list = [1850:2014];
    end

    if sens_id == 0,
        P.do_region = 1;
        P.do_season = 0;
        P.do_decade = 1;
        P.yr_interval = 5;
    elseif sens_id == 1,
        P.do_region = 0;
        P.do_season = 0;
        P.do_decade = 1;
        P.yr_interval = 5;
    elseif sens_id == 2,
        P.do_region = 1;
        P.do_season = 0;
        P.do_decade = 1;
        P.yr_interval = 10;
    end
end
