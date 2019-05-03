HM_load_package;

% *************************************************************************
% Download and unzip file
% *************************************************************************
tic;
load('chan_et_al_2019_directories.mat','dir_data')
dir_now = pwd;
cd(dir_data) 
if exist('Supporting_Data.tar.gz', 'file') ~= 2,
    disp(['downloading data ...'])
    url= ['https://dataverse.harvard.edu/api/access/datafile/3424402'];
    filename = 'Supporting_Data.tar.gz';
    websave(filename,url);
    !tar -zxvf Supporting_Data.tar.gz
    cd(dir_now)
    disp(['Downloading data takes ',num2str(toc,'%6.0f'),' seconds'])
end

% *************************************************************************
% Move supporting data
%% *************************************************************************
dir_from = [dir_data,'Supporting_Data/'];        % TODO 
                                             % change to name of untarred folder

dir_to = [dir_data,'ICOADSb/HM_SST_Bucket/'];
file = 'Stats_HM_SST_Bucket_deck_level_1.mat';
if exist([dir_to,file], 'file') == 2,
    disp('File ''Stats_HM_SST_Bucket_deck_level_1.mat'' exists.  Skip ...')
else
    try
        movefile([dir_from,file],[dir_to,file]);
        disp(['Moving ''Stats_HM_SST_Bucket_deck_level_1.mat''...'])
    catch
        disp(['Error in moving ''Stats_HM_SST_Bucket_deck_level_1.mat'''])
    end
end
disp(' ')

disp(['Moving all other supporting data to their target directories...'])
cd(dir_data) 
! mv -f Supporting_Data/ICOADS_Mis/*  ICOADS3/ICOADS_Mis/
! mv -f Supporting_Data/Miscellaneous/*  ICOADSb/Miscellaneous/
cd(dir_now)