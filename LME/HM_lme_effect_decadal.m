function group_decade = HM_lme_effect_decadal(yrs,yr_start,yr_interval)

    group_decade = ceil((yrs-yr_start+1)/yr_interval);

end
