function app_exp = HM_function_set_case(do_correct,do_eqwt,do_kent,do_trim,sigma_obs)

    if do_correct == 0 && do_eqwt == 1 && do_kent == 0 && do_trim == 0,
        app_exp = 'eq_wt';
    elseif do_correct == 0 && do_eqwt == 0 && do_kent == 0 && do_trim == 0,
        app_exp = 'mini_err';
    elseif do_correct == 0 && do_eqwt == 0 && do_kent == 1 && do_trim == 0,
        app_exp = 'mini_err_kent';
    elseif do_correct == 1 && do_eqwt == 1 && do_kent == 0 && do_trim == 0,
        app_exp = 'cor_err';
    elseif do_correct == 1 && do_eqwt == 1 && do_kent == 1 && do_trim == 0,
        app_exp = 'cor_err_kent';
    elseif do_correct == 1 && do_eqwt == 1 && do_kent == 0 && do_trim == 1,
        app_exp = 'cor_err_trim';
    elseif do_correct == 1 && do_eqwt == 1 && do_kent == 1 && do_trim == 1,
        app_exp = 'cor_err_kent_trim';
    end
end
