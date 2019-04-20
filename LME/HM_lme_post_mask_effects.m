function out = HM_lme_post_mask_effects(out,M_dck,do_region,do_season,do_decade,do_hierarchy_random)

    [~,Pos]= ismember(out.unique_grp(:,1:2),out.unique_nat,'rows');

    if do_region == 1,
        if do_hierarchy_random == 1,
            out.bias_region = HM_lme_nansum_effects(out.bias_region_nat,...
                                                out.bias_region_dck,Pos,M_dck.logic_region);
            out.bias_region_rnd = HM_lme_nansum_effects(out.bias_region_rnd_nat,...
                                                out.bias_region_rnd_dck,Pos,M_dck.logic_region);
            out.bias_region_std = sqrt(HM_lme_nansum_effects(out.bias_region_std_nat.^2,...
                                                out.bias_region_std_dck.^2,Pos,M_dck.logic_region));
        else
            out.bias_region     = out.bias_region_dck;
            out.bias_region_rnd = out.bias_region_rnd_dck;
            out.bias_region_std = out.bias_region_std_dck;
        end
    end

    if do_season == 1,
        if do_hierarchy_random == 1,
            out.bias_season = HM_lme_nansum_effects(out.bias_season_nat,...
                                                out.bias_season_dck,Pos,M_dck.logic_season);
            out.bias_season_rnd = HM_lme_nansum_effects(out.bias_season_rnd_nat,...
                                                out.bias_season_rnd_dck,Pos,M_dck.logic_season);
            out.bias_season_std = sqrt(HM_lme_nansum_effects(out.bias_season_std_nat.^2,...
                                                out.bias_season_std_dck.^2,Pos,M_dck.logic_season));
        else
            out.bias_season     = out.bias_season_dck;
            out.bias_season_rnd = out.bias_season_rnd_dck;
            out.bias_season_std = out.bias_season_std_dck;
        end
    end

    if do_decade == 1,
        if do_hierarchy_random == 1,
            out.bias_decade = HM_lme_nansum_effects(out.bias_decade_nat,...
                                                out.bias_decade_dck,Pos,M_dck.logic_decade);
            out.bias_decade_rnd = HM_lme_nansum_effects(out.bias_decade_rnd_nat,...
                                                out.bias_decade_rnd_dck,Pos,M_dck.logic_decade);
            out.bias_decade_std = sqrt(HM_lme_nansum_effects(out.bias_decade_std_nat.^2,...
                                                out.bias_decade_std_dck.^2,Pos,M_dck.logic_decade));
        else
            out.bias_decade     = out.bias_decade_dck;
            out.bias_decade_rnd = out.bias_decade_rnd_dck;
            out.bias_decade_std = out.bias_decade_std_dck;
        end
    end
end
