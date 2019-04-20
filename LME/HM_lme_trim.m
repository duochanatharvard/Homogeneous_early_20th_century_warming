function logic_pass = HM_lme_trim(input,do_grid_season,mx,my,mt)

    input = input(:)';

    if do_grid_season == 0,

        % global trim

        trim = sqrt(CDC_var(input))*3;
        logic_pass = abs(input) < trim;

    else

        % regional trim

        time_vec = datevec(mt/24);
        month = time_vec(:,2)';
        month( month == 12) = 0;
        month = month + 1;
        season = ceil(month / 3);
        x = discretize(mx,[0:5:360]);
        y = discretize(my,[-90:5:90]);
        data = [input; x; y; season];

        clear('K','K_re','N','STD');
        for ct_x = 1:72
            data_x = data(:,data(2,:) == ct_x);
            for ct_y = 1:36
                data_y = data_x(:,data_x(3,:) == ct_y);
                for ct_s = 1:4
                    data_s = data_y(:,data_y(4,:) == ct_s);
                    if ~isempty(data_s),
                        N(ct_x,ct_y,ct_s) = size(data_s,2);
                        STD(ct_x,ct_y,ct_s) = sqrt(CDC_var(data_s(1,:)));
                    else
                        N(ct_x,ct_y,ct_s) = 0;
                        STD(ct_x,ct_y,ct_s) = nan;
                    end
                end
            end
        end

        id = sub2ind([72 36 4],x,y,season);
        sd = STD(id);
        logic_pass = abs(input) < (sd * 3);

    end
end
