% A scipt that pick out ICOADS pairs and
% subset pairs by distance in each month
HM_load_package;

% *******************
% Fixed Parameters **
% *******************
varname = 'SST';
method  = 'Bucket';
pick_limit = 1850;

env  = 1;

for yr = 2014:-1:pick_limit
    for mon = 1:12

        % ######################################################################
        % The following parameters should be fixed
        % ######################################################################
        if 1,                                      % Pick out all possible pairs
            do_NpD   = 1;                          % Group by nation and deck
            do_rmdup = 0;                          % Do not remove DUPS != 0
            do_other = 0;                          % Do not combine JP Kobe collections
                                                   % at this step, but they will be combined
                                                   % in later steps
            do_rmsml = 0;                          % Do not remove small contributing groups

            HM_pair_01_Raw_Pairs_dup...
                      (yr,mon,do_NpD,varname,method,do_rmdup,do_rmsml,env,do_other);
        end

        % ######################################################################
        % Note that parameters listed here are to
        % reproduce results in the main texts
        % They can be updated in various ways to perform sensitivity tests
        % ######################################################################
        if 1,
            do_NpD   = 1;                          % Group by nation and deck
            P.do_rmdup = 0;                        % Do not remove DUPS != 0
            P.do_rmsml = 0;                        % Do not remove small contributing groups
            P.do_fewer_first = 0;                  % Screen pairs with ascending distance
            HM_pair_02_Screen_Pairs_dup(yr,mon,do_NpD,varname,method,env,P);

        end
    end
end
