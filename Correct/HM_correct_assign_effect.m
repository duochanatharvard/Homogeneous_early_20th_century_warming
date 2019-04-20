function C = HM_correct_assign_effect(lme,P,do_random,do_individual,en)

    if do_random == 0,

        C.bias_fixed_rand  = lme.out.bias_fixed;

        if P.do_region == 1,
            C.bias_region_rand = lme.out.bias_region;
        end

        if P.do_season == 1,
            C.bias_season_rand = lme.out.bias_season;
        end

        if P.do_decade == 1,
            C.bias_decade_rand = lme.out.bias_decade;
        end

    else

        C.bias_fixed_rand  = lme.out.bias_fixed_random(en,:)';

        if P.do_region == 1,
            C.bias_region_rand = lme.out.bias_region_rnd(:,:,en);
        end

        if P.do_season == 1,
            C.bias_season_rand = lme.out.bias_season_rnd(:,:,en);
        end

        if P.do_decade == 1,
            C.bias_decade_rand = lme.out.bias_decade_rnd(:,:,en);
        end

    end

    if do_individual == 1,

        n = en;

        C.bias_fixed_rand([1:n-1 n+1:end]) = 0;

        if P.do_region == 1,
            C.bias_region_rand(:,[1:n-1 n+1:end]) = 0;
        end

        if P.do_season == 1,
            C.bias_season_rand(:,[1:n-1 n+1:end]) = 0;
        end

        if P.do_decade == 1,
            C.bias_decade_rand(:,[1:n-1 n+1:end]) = 0;
        end

    end
end
