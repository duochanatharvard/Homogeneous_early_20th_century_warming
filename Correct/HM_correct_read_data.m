function [DATA,ratio] = HM_correct_read_data(varname,method,yr,mon,dir_load,EP,env)

    if ~isfield(EP,'do_rmdup'),
        EP.do_rmdup = 0;
    end

    if ~isfield(EP,'do_add_JP'),
        EP.do_add_JP = 0;
    end
    
    if ~exist('env','var'),
        env = 1;            % 1 means on odyssey
    end

    % ###############################################################
    % ###############################################################
    % ###############################################################
    cmon = CDF_num2str(mon,2);
    % In the following set up, small nations are never thrown away
    do_NpD = 1;
    do_rmsml = 0;
    do_connect_deck = 1;
    do_other = 0;       %connect JP Kobe collections

    [DATA,ratio] = HM_pair_function_read_data...
          (yr,mon,do_NpD,varname,method,EP.do_rmdup,do_rmsml,env,do_connect_deck,do_other);

    if EP.do_add_JP == 1,
        l_kobe  = ismember(DATA(10,:),[762 118 119]);
        l_whole = DATA(14,:) == fix(DATA(14,:));
        l_add   = DATA(1,:) > 1932 & l_kobe & l_whole;
        DATA(14,l_add) = DATA(14,l_add) + 0.46;
    end

    DATA = DATA([8 9 14 15 20 21 10 2],:);
end
