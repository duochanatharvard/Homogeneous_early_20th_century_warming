% HM_Step_02_Screen_Pairs(yr,mon)
function HM_pair_02_Screen_Pairs_dup...
            (yr,mon,do_NpD,varname,method,env,P)

    % *******************
    % Input and Output **
    % *******************
    if ~exist('env','var'),
        env = 1;            % 1 means on odyssey
    end

    dir_home = HM_OI('home',env);

    app = ['HM_',varname,'_',method];
    if app(end)=='_', app(end)=[]; end
    app(end+1) = '/';
    dir_load = [dir_home,HM_OI('raw_pairs',env,app)];
    dir_save = [dir_home,HM_OI('screen_pairs',env,app)];

    % ********************************
    % File name for the saving data **     # TODO
    % ********************************
    save_app = '_all_pairs';
    cmon = CDF_num2str(mon,2);
    if strcmp(method,'Bucket'),
        file_load = [dir_load,'IMMA1_R3.0.0_',num2str(yr),'-',...
        cmon,'_Bucket_Pairs_c',save_app,'.mat'];
    end

    fid = fopen(file_load);
    if fid > 0,
        fclose(fid);
        load(file_load)

        % ****************************************************************
        % Remove pairs that come from the same group                    **
        % ****************************************************************
        N_data = size(Pairs,1)/2;
        if do_NpD == 0,
            logic_remove = all(Pairs([20:21],:)' == Pairs([20:21]+21,:)',2);
        else
            logic_remove = all(Pairs([20:21 10],:)' == Pairs([20:21 10]+21,:)',2);
        end
        Pairs(:,logic_remove) = [];
        Meta(logic_remove,:) = [];
        clear('logic_remove','ans')

        % ****************************************************************
        % Remove duplicate pairs                                        **
        % ****************************************************************
        if P.do_rmdup == 1,
            l1 = Pairs(4,:)    ~= 0;
            l2 = Pairs(4+21,:) ~= 0;
            logic_remove = l1 | l2;
            Pairs(:,logic_remove) = [];
            Meta(logic_remove,:) = [];
        end

        % ***********************************
        % Remove small contributing groups **
        % ***********************************
        if P.do_rmsml > 0,

            list_large_group = HM_pair_function_large_groups(do_NpD,varname,method,P.do_rmsml);

            if do_NpD == 0,
                l_use = ismember(Pairs([20:21],:)',   list_large_group,'rows');
            else
                l_use = ismember(Pairs([20:21 10],:)',list_large_group,'rows');
            end

            Pairs = Pairs(:,l_use);
            Meta  = Meta(l_use,:);
        end

        % *************************************
        % Compute the distance between pairs **
        % *************************************
        N_ascii = N_data;                                       %TODO
        id_lon  = 8;                                            %TODO
        id_lat  = 9;                                            %TODO
        id_utc  = 6;                                            %TODO
        id_lcl  = 5;

        % compute distance of individual pairs
        dist_s = distance(Pairs(id_lat,:),Pairs(id_lon,:),...
                          Pairs(id_lat+N_ascii,:),Pairs(id_lon+N_ascii,:));
        dist_c = abs(Pairs(id_utc,:) - Pairs(id_utc+N_ascii,:));
        dist = dist_c / 12 + dist_s;

        if P.do_fewer_first == 0,
            [~,I] = sort(dist);
        else
            % compute frequency of individual groups
            if do_NpD == 0,
                [unique_pairs,~,J] = unique([Pairs([20:21],:)'    Pairs([20:21]+N_ascii,:)'],'rows');
            else
                [unique_pairs,~,J] = unique([Pairs([20:21 10],:)' Pairs([20:21 10]+N_ascii,:)'],'rows');
            end
            J_h  = hist(J,1:1:max(J));
            [~,J_rank] = sort(J_h);
            freq = nan(size(J))';
            for ct = 1:numel(J_rank)
                freq(J == J_rank(ct)) = ct;
            end

            loss_function = freq * 10000 + dist;
            [~,I] = sort(loss_function);
        end
        clear('dist_s','dist_c','loss_function','freq','J','J_h','J_rank')

        % ********************************
        % To transform UID into numbers **
        % ********************************
        point_pairs        = [Pairs(7,:)' Pairs(7+N_ascii,:)'];
        [point_unique,~,J] = unique(point_pairs(:));
        J_pairs            = [J(1:numel(J)/2) J(numel(J)/2+1:end)];

        % Remove ships that does not provide additional information ---------------
        disp('eliminating duplicate pairs')
        % each individual data point is only used once
        group = false(1,numel(point_unique));
        logic_use = false(1,size(J_pairs,1));
        for i = I  % starting searching from the smallest distance

            clear('ct1','ct2')
            ct1 = group(J_pairs(i,1));
            ct2 = group(J_pairs(i,2));

            if ct1 == 0 && ct2 == 0,
                group(1,J_pairs(i,:)) = 1;
                logic_use(i) = 1;
            end
        end
        clear('ct','ct1','ct2','dist_sort','dist')

        % **********************
        % Screening the pairs **
        % **********************
        Pairs   = Pairs(:,logic_use);
        Meta    = Meta(logic_use,:);
        clear('I','J','H_airs','logic_use','point_pairs')

        % ****************************
        % File name for saving data **     # TODO
        % ****************************
        save_app = ['_NpD_',num2str(do_NpD),'_rmdup_',...
                    num2str(P.do_rmdup),'_rmsml_',num2str(P.do_rmsml),...
                    '_fewer_first_',num2str(P.do_fewer_first)];
        cmon = CDF_num2str(mon,2);
        if strcmp(method,'Bucket'),
            file_save = [dir_save,'IMMA1_R3.0.0_',num2str(yr),'-',...
            cmon,'_Bucket_Screen_Pairs_c',save_app,'.mat'];
        end

        if strcmp(varname,'SST'),
            % *************************************
            % Assigning Diurnal Signal From Buoy **
            % *************************************
            dir_da = [dir_home,HM_OI('diurnal',env)];
            disp('Assign diurnal cycle')
            clear('CLIM_DASM','Diurnal_Shape')
            load([dir_da,'DA_SST_Gridded_BUOY_sum_from_grid.mat'],'CLIM_DASM');
            load([dir_da,'Diurnal_Shape_SST.mat'],'Diurnal_Shape');
            Diurnal_Shape = squeeze(Diurnal_Shape(:,:,3,:));

            % .......................
            % Locate diurnal cycle ..
            % .......................
            clear('latitude','logitude','months','hours','DA_mgntd','DA_shape',...
                  'Y','DASHP_id','shp_temp','SST_adj');
            latitude  = [Pairs(id_lat,:)     Pairs(id_lat + N_data,:)];
            longitude = [Pairs(id_lon,:)     Pairs(id_lon + N_data,:)];
            months    = [Pairs(2,:)          Pairs(2 + N_data,:)];
            hours     = [Pairs(id_lcl,:)     Pairs(id_lcl + N_data,:)];

            DA_mgntd  = HM_function_grd2pnt(longitude,latitude,months,CLIM_DASM,5,5,1);
            Y = fix((latitude+90)/5)+1; Y(Y>36)=36;
            DASHP_id = sub2ind([36 24 12], Y, hours, months);
            DA_shape  = Diurnal_Shape(DASHP_id);

            % .........................
            % Compute diurnal signal ..
            % .........................
            SST_diurnal_adj = DA_shape .* DA_mgntd;

            % ........................
            % Assign diurnal signal ..
            % ........................
            N = numel(SST_diurnal_adj)/2;
            SST_diurnal_adj  = [SST_diurnal_adj(1:N);  SST_diurnal_adj(N+1:end)];
            DA_shape = [DA_shape(1:N); DA_shape(N+1:end)];
            DA_mgntd = [DA_mgntd(1:N); DA_mgntd(N+1:end)];
            SST_diurnal_adj(isnan(SST_diurnal_adj)) = 0;

            save(file_save,'Pairs','Meta','DA_shape','DA_mgntd','SST_diurnal_adj','-v7.3')
        else
            save(file_save,'Pairs','Meta','-v7.3')
        end
    end
end
