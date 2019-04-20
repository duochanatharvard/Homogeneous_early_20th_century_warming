% ICOADS_Step_03_WM(yr, mon)
%
%  The following function computes the winsorized mean of SST on one degree
%  and pentad (5-day) resolution grids. Here, the winsorized mean cuts off
%  at 25% and 75% quantile of samples in individual grids.
%
%
% Last update: 2018-08-15


function ICOADS_Step_03_WM(yr, mon, varname)

    if ~exist('varname','var'),
        varname = 'SST';
    end

    % recommend to use nansum that returns nan rather than 0 when inputs are all nan
    addpath('/n/home10/dchan/Matlab_Tool_Box')

    % Set direcotry of files  ---------------------------------------------
    dir_load  = ICOADS_OI('pre_QC');
    dir_save  = ICOADS_OI('WM');
    cmon = '00';  cmon(end-size(num2str(mon),2)+1:end) = num2str(mon);
    file_load = [dir_load,'IMMA1_R3.0.0_',num2str(yr),'-',cmon,'_preQC.mat'];
    if strcmp(varname,'SST'),
        file_save = [dir_save,'IMMA1_R3.0.0_',num2str(yr),'-',cmon,'_WM_',varname,'.mat'];
    else
        file_save = [dir_save,'IMMA1_R3.0.0_',num2str(yr),'-',cmon,'_WM_',varname,'.mat'];
    end

    % Compute winsorized mean   -------------------------------------------

    fid=fopen(file_load,'r');

    if(fid~=-1)

        fclose(fid);

        if strcmp(varname,'SST'),

            load (file_load,'C0_YR','C0_LON','C0_LAT','C0_DY',...
                  'C0_SST','C0_OI_CLIM','QC_NON_SST','C1_SF','C1_SNC','C1_ZNC');
            C0_QC_ME_1 = QC_NON_SST == 1 & ((C0_SST > (C0_OI_CLIM-10)) & (C0_SST < (C0_OI_CLIM+10)));
            C0_QC_ME_1(C0_SST > 37 | C0_SST < -5) = 0;
            C0_QC_ME_1(C1_SNC > 5) = 0;
            C0_QC_ME_1(C1_ZNC > 5 & C0_YR > 1859) = 0;

            clear('in_var','in_lon','in_lat','in_dy');
            in_var = C0_SST(C0_QC_ME_1) - C0_OI_CLIM(C0_QC_ME_1);
            in_lon = C0_LON(C0_QC_ME_1);
            in_lat = C0_LAT(C0_QC_ME_1);
            in_day  = C0_DY(C0_QC_ME_1);

        elseif strcmp(varname,'NMAT'),

            load (file_load,'C0_YR','C0_LON','C0_LAT','C0_DY','C0_AT','C0_ERA_CLIM',...
                            'C1_DCK','QC_NON_AT','C1_AF','C1_ANC','C1_PT','C1_ND','C1_ZNC');
            C0_QC_ME_1 = QC_NON_AT == 1 & ((C0_AT > (C0_ERA_CLIM-10)) & (C0_AT < (C0_ERA_CLIM+10)));
            C0_QC_ME_1(C1_ANC > 5) = 0;
            C0_QC_ME_1(C1_ZNC > 5 & C0_YR > 1859) = 0;
            % C0_QC_ME_1(~ismember(C1_PT,[0 1 2 3 4 5 10 11 12 17])) = 0;

            % Should exclude suez from deck 193 until 1893,
            % exclude deck 195 during WWII,
            % and exclude deck 780 platform 5 for all times.

            C0_QC_ME_1(C1_DCK == 780 & C1_PT == 5) = 0;
            if yr >= 1942 && yr <= 1946,

                dir_era   = ICOADS_OI('Mis');
                dmat1 = load([dir_era,'/Dif_DMAT_NMAT_1929_1941.mat']);
                dmat2 = load([dir_era,'/Dif_DMAT_NMAT_1947_1956.mat']);

                corr1 = re_function_general_grd2pnt(C0_LON,C0_LAT,[],dmat1.Dif_DMAT_NMAT,5,5,1);
                corr2 = re_function_general_grd2pnt(C0_LON,C0_LAT,[],dmat2.Dif_DMAT_NMAT,5,5,1);
                corr = corr1 * (yr - 1941)/6 + corr2 * (1 - (yr - 1941)/6);

                C0_AT = C0_AT - corr;
                C0_QC_ME_1(C1_ND == 1) = 0;
                C0_QC_ME_1(C1_DCK == 195) = 0;

            else

                if yr <= 1892, % Also need to throw away the deck 193,
                    mask = zeros(72,36);
                    mask([57:72],[27:29])     = 1;
                    mask([71:72 1:9],[26:27]) = 1;
                    mask([3:9],[17:26])       = 1;
                    mask([10:19],[17:21])     = 1;
                    mask([20:21],[17:19])     = 1;
                    logic_bad_193 = re_function_general_grd2pnt(C0_LON,C0_LAT,[],mask,5,5,1);
                    logic_remove  = C1_DCK == 193 & logic_bad_193 == 1;
                    C0_QC_ME_1(logic_remove) = 0;
                end

                C0_QC_ME_1(C1_ND == 2) = 0;
            end

            clear('in_var','in_lon','in_lat','in_dy');
            in_var = C0_AT(C0_QC_ME_1) - C0_ERA_CLIM(C0_QC_ME_1);
            in_lon = C0_LON(C0_QC_ME_1);
            in_lat = C0_LAT(C0_QC_ME_1);
            in_day  = C0_DY(C0_QC_ME_1);
        end

        if (isempty(in_var) == 0)
            [var_grd,~] = re_function_general_pnt2grd_3d(in_lon,in_lat,in_day,in_var,[],1,1,5,2,'pentad');
            [WM,ST,NUM] = sst_function_step_002_WM_ICOADS_re(var_grd);
        else
            WM = NaN(360,180,6);
            ST = NaN(360,180,6);
            NUM = NaN(360,180,6);
        end

        clear('in_var','in_lon','in_lat','in_dy');
        save([file_save],'WM','ST','NUM','-v7.3');
    else
        disp([file_load ,' does not exist!']);
    end
    disp([file_save ,' is finished!']);
    disp([' ']);
end

% -------------------------------------------------------------------------
function [WM,ST,NUM] = sst_function_step_002_WM_ICOADS_re(var_grd)

    WM  = NaN(size(var_grd));
    ST  = NaN(size(var_grd));
    NUM = NaN(size(var_grd));

    for i = 1:size(var_grd,1)
        for j = 1:size(var_grd,2)
            for k = 1:size(var_grd,3)

                clear('temp','temp1','temp0','logic')
                temp = var_grd{i,j,k};
                logic = ~isnan(temp);

                if nnz(logic),

                    temp1 = temp(logic);
                    temp0 = temp1;

                    if(numel(temp1)>=4)
                        clear('q25','q75','logic_1','logic_2')
                        q25 = quantile(temp1,0.25);
                        q75 = quantile(temp1,0.75);
                        logic_1 = temp1 <= q25;
                        logic_2 = temp1 >= q75;
                        temp1(logic_1) = q25;
                        temp1(logic_2) = q75;
                        WM(i,j,k) = nanmean(temp1);
                    else
                        WM(i,j,k) = nanmean(temp1);
                    end

                    ST(i,j,k) = sqrt(nansum((temp0 - WM(i,j,k)).^2) / numel(temp1));
                    NUM(i,j,k)= numel(temp1);

                end
            end
        end
    end
end

% -------------------------------------------------------------------------
function [var_grd,id_grd] = re_function_general_pnt2grd_3d(in_lon,in_lat,...
                        in_day,in_var,in_id,reso_x,reso_y,reso_t,mode,tname)


    % Reshape longitude and latitude --------------------------------------
    in_lon = rem(in_lon + 360*5, 360);
    in_lat(in_lat>90) = 90;
    in_lat(in_lat<-90) = -90;

    if(isempty(in_day))
        dimension = '2D';
    else
        dimension = '3D';
    end

    % Determine length in z direction -------------------------------------
    if (strcmp(dimension,'2D'))
    	dim = 1;
    else
        if strcmp(tname,'pentad')
            dim = fix(30/reso_t);
        elseif strcmp(tname,'hourly')
            dim = fix(24/reso_t);
        elseif strcmp(tname,'monthly')
            dim = fix(12/reso_t);
        elseif strcmp(tname,'seasonal')
            dim = fix(4/reso_t);
        end
    end

    % Allocate Working space ----------------------------------------------
    clear('var_grd','id_grd')
    if (isempty(in_id))
        var_grd = cell(360/reso_x,180/reso_y,dim);
    else
        var_grd = cell(360/reso_x,180/reso_y,dim);
        id_grd  = cell(360/reso_x,180/reso_y,dim);
    end

    % Assign subscript ----------------------------------------------------
    x = fix((in_lon)/reso_x)+1;
    x (x>(360/reso_x)) = x (x>(360/reso_x)) - (360/reso_x);
    y = fix((in_lat+90)/reso_y)+1;
    y (y>(180/reso_y)) = 180/reso_y;
    if (strcmp(dimension,'2D'))
        z = ones(size(x));
    else
        z = min(fix((in_day-0.01)/reso_t)+1,dim);
    end

    % Put points into grids -----------------------------------------------
    if (mode == 1)
        for i = 1:size(in_var,2)
            clear('temp','temp_kind')
            var_grd{x(i),y(i),z(i)} = [var_grd{x(i),y(i),z(i)} in_var(:,i)];
            if (isempty(in_id) == 0)
               id_grd{x(i),y(i),z(i)} = [id_grd{x(i),y(i),z(i)} ; in_id(i,:)];
            end
        end
    else
        [in_uni,~,J] = unique([x' y' z'],'rows');
        for i = 1:size(in_uni,1)
            clear('logic')
            logic = J == i;
            var_grd{in_uni(i,1),in_uni(i,2),in_uni(i,3)} = in_var(:,logic);
            if (isempty(in_id) == 0)
                id_grd{in_uni(i,1),in_uni(i,2),in_uni(i,3)} = in_id(logic,:);
            end
        end
    end

    if (isempty(in_id))
        id_grd = [];
    end
end

% -------------------------------------------------------------------------
function out_pnts = re_function_general_grd2pnt(in_lon,in_lat,...
                                        in_dy,in_grd,reso_x,reso_y,reso_t)

    in_lon = rem(in_lon + 360*5, 360);
    x = fix(in_lon/reso_x)+1;
    num_x = 360/reso_x;
    x(x>num_x) = x(x>num_x) - num_x;

    in_lat(in_lat>90) = 90;
    in_lat(in_lat<-90) = -90;
    y = fix((in_lat+90)/reso_y) +1;
    num_y = 180/reso_y;
    y(y>num_y) = num_y;

    if(isempty(in_dy))
        index = sub2ind(size(in_grd),x,y);
    else
        z = min(fix((in_dy-0.01)./reso_t)+1,size(in_grd,3));
        index = sub2ind(size(in_grd),x,y,z);
    end

    out_pnts = in_grd (index);
    out_pnts(abs(out_pnts)>1e8) = NaN;
end
