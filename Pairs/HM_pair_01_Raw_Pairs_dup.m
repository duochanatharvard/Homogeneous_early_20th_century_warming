% This version add options for removing duplicating records and
% can exclude records from small contributing nation or groups in the first place
% But mode to choose between "longitude " or "great circle distance" is removed.
% Now, only great circle distance is used.
%
% 2018-10-19: In the latest version, this part should pick out all pairs without
% throwing away anything. So the following parameters are recommended
% do_NpD = 1;
% do_rmdup = 0;
% do_rmsml = 0;
% dp_other = 0;    % This is to connect Japanese Kobe decks
%
% Last update: 2018-10-05
function HM_pair_01_Raw_Pairs_dup(yr,mon,do_NpD,varname,method,do_rmdup,do_rmsml,env,do_other)

    % *******************
    % Input and Output **
    % *******************
    if ~exist('do_other','var'),
        do_other = 0;
    end

    if ~exist('env','var'),
        env = 1;             % 1 means on odyssey
    end
    dir_home = HM_OI('home',env);

    app = ['HM_',varname,'_',method];
    if app(end)=='_', app(end)=[]; end
    app(end+1) = '/';

    dir_save = [dir_home,HM_OI('raw_pairs',env,app)];

    % *********************************
    % Loading data                   **
    % *********************************
    DATA = HM_pair_function_read_data...
                          (yr,mon,do_NpD,varname,method,do_rmdup,do_rmsml,env,1,do_other);

    % ********************************
    % File name for the saving data **     # TODO
    % ********************************
    save_app = '_all_pairs';
    cmon = CDF_num2str(mon,2);
    if strcmp(varname,'SST'),
        if strcmp(method,'Bucket'),
            file_save = [dir_save,'IMMA1_R3.0.0_',num2str(yr),'-',...
            cmon,'_Bucket_Pairs_c',save_app,'.mat'];
        end
    end

    % ****************
    % Pickout pairs **
    % ****************
    if ~isempty(DATA),
        if do_NpD == 1,
            Markers = DATA([20 21 10],:)';
        else
            Markers = DATA([20 21],:)';
        end
        [Pairs,Meta] = HM_function_get_pairs...
                                (DATA,Markers,8,9,6,5,[],300,3,48,1);
        if ~isempty(Pairs),
            disp('Saving data')
            save(file_save,'Pairs','Meta','-v7.3');
        end
    end
end
