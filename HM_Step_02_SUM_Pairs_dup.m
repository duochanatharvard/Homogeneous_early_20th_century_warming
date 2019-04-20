% A scipt that sum all pairs into a single file
HM_load_package;

varname = 'SST';
method  = 'Bucket';
pick_limit = 1850;

% *****************
% Set Parameters **
% *****************
do_NpD     = 1;                   % Use nation and deck to group measurements
P.do_rmdup = 0;                   % Do not remove DUPS != 0
P.do_rmsml = 0;                   % Do not remove small contributing groups
P.do_fewer_first = 0;             % Screen pairs with ascending distance
yr_list = [pick_limit:2014];

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
dir_load = [dir_home,HM_OI('screen_pairs',env,app)];
dir_save = [dir_home,app];

% *************************
% Summing Screened Pairs **
% *************************
DATA = [];
for yr = yr_list

    disp(['starting year:',num2str(yr)])

    for mon = 1:12

        % ******************************
        % File name for summing pairs **     # TODO
        % ******************************
        save_app = ['_NpD_',num2str(do_NpD),'_rmdup_',...
                    num2str(P.do_rmdup),'_rmsml_',num2str(P.do_rmsml),...
                    '_fewer_first_',num2str(P.do_fewer_first)];

        cmon = CDF_num2str(mon,2);
        if strcmp(varname,'SST'),
            if strcmp(method,'Bucket'),
                file_load = [dir_load,'IMMA1_R3.0.0_',num2str(yr),'-',...
                cmon,'_Bucket_Screen_Pairs_c',save_app,'.mat'];
            end
        end

        % ********************************
        % Summing up the screened pairs **
        % ********************************
        clear('Pairs','Meta','SST_diurnal_adj','DA_mgntd','DA_shape')
        fid = fopen(file_load);
        if fid > 0,
            fclose(fid);
            load(file_load)

            DATA = [DATA [Pairs; SST_diurnal_adj; DA_mgntd; DA_shape]];
        end
    end
end

% ****************************************
% File name for saving the summed pairs **     # TODO
% ****************************************
cmon = CDF_num2str(mon,2);
yr_text = [num2str(yr_list(1)),'_',num2str(yr_list(end))];
file_save = [dir_save,'Step_03_SUM_Pairs/SUM_',app(1:end-1),...
                            '_Screen_Pairs_c_once_',yr_text,'',save_app,'.mat'];
save(file_save,'DATA','-v7.3')
