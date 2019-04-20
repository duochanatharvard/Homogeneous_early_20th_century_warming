function var_obs = HM_lme_var_obs(x1,x2,y1,y2,varname,method)

    if strcmp(varname,'SST'),

       if strcmp(method,'Bucket'),
           % var_temp = [0.9 nan nan nan 1.1 nan nan nan nan 1.4 nan 1.2;
           %            0.9 0.8 0.9 nan nan nan nan nan 0.9 0.9 1.1 1.0;
           %            1.0 1.0 1.2 1.6 1.5 1.1 1.2 1.1 1.6 1.1 1.0 1.0;
           %            1.1 nan nan 1.9 1.4 1.1 1.3 nan 1.8 1.3 0.9 0.9];

            var_temp = [0.9 .95  1.0  1.05 1.1 1.16 1.22 1.28 1.34 1.4 1.3 1.2;
                        0.9 0.8  0.9  .92  .92 .92  .92  .92  0.9  0.9 1.1 1.0;
                        1.0 1.0  1.2  1.6  1.5 1.1  1.2  1.1  1.6  1.1 1.0 1.0;
                        1.1 1.37 1.63 1.9  1.4 1.1  1.3  1.55 1.8  1.3 0.9 0.9];

        else
          % var_temp = [1.4 nan nan nan 1.4 nan nan nan 0.8 1.9 nan 1.4;
          %             1.4 1.1 1.2 1.1 nan nan nan 1.5 1.3 1.1 1.4 nan;
          %             1.4 nan 1.4 1.8 1.6 1.3 1.4 1.5 1.7 1.7 1.4 1.4;
          %             1.5 nan nan 1.9 1.5 1.4 1.4 nan nan 1.7 1.2 1.3];

           var_temp = [1.4 1.4 1.4 1.4 1.4 1.25 1.1 0.95 0.8 1.9 1.65 1.4;
                       1.4 1.1 1.2 1.1 1.2 1.3 1.4 1.5 1.3 1.1 1.4 1.4;
                       1.4 1.4 1.4 1.8 1.6 1.3 1.4 1.5 1.7 1.7 1.4 1.4;
                       1.5 1.63 1.77 1.9 1.5 1.4 1.4 1.5 1.6 1.7 1.2 1.3];

        end
        var_temp = var_temp(:,[12 1:11]);
        var_temp = [var_temp(1,:); var_temp];

    else

       % var_temp = [1.7  1.5  3.0  2.7  1.2  1.6  1.3  3.3  nan  nan  2.4  2.3
       %             1.2  1.3  1.3  1.7  0.9  1.6  1.4  1.4  1.0  1.3  2.0  1.6
       %             nan  nan  1.2  1.1  1.2  1.4  1.8  1.0  1.0  1.0  1.3  0.8
       %             nan  nan  nan  0.9  1.1  nan  1.6  0.9  nan  nan  1.0  0.9];

        var_temp = [1.7  1.5  3.0  2.7  1.2  1.6  1.3  3.3  3.0  2.7  2.4  2.3
                    1.2  1.3  1.3  1.7  0.9  1.6  1.4  1.4  1.0  1.3  2.0  1.6
                    0.93 1.07 1.2  1.1  1.2  1.4  1.8  1.0  1.0  1.0  1.3  0.8
                    0.9  0.9  0.9  0.9  1.1  1.35 1.6  0.9  0.93 0.96 1.0  0.9];

        var_temp = var_temp(4:-1:1,[7:12 1:6]);
        var_temp = [var_temp(1,:); var_temp];
    end

    mx = HM_function_mean_period([x1; x2],360);
    my = nanmean([y1; y2],1);
    temp_x   = ceil(mx/30);
    temp_x(temp_x <= 0) = 1; temp_x(temp_x > 12) = 12;
    temp_y   = ceil((my+75)/30);
    temp_y(temp_y <= 0) = 1; temp_y(temp_y > 5) = 5;

    index    = sub2ind([5 12],temp_y,temp_x);
    var_obs  = var_temp(index);
    var_obs = var_obs.^2;

end
