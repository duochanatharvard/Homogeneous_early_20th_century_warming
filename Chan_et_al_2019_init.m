% Chan_et_al_2019_init(dir_data)
% Input dir_data is the directory for storing data
%    default is under the code directory.

function Chan_et_al_2019_init(dir_data)

    % ********************************************
    % Make directories
    % ********************************************
    dir_code = [pwd,'/'];
    if ~exist('dir_data','var'), dir_data = [dir_code,'DATA/']; end
    if dir_data(end)~= '/',  dir_data = [dir_data,'/']; end
    
    mkdir(dir_data)
    cd(dir_data)
    
    mkdir ICOADS3
    mkdir ICOADS3/ICOADS_00_raw_zip/
    mkdir ICOADS3/ICOADS_00_raw/
    mkdir ICOADS3/ICOADS_01_mat_files/
    mkdir ICOADS3/ICOADS_02_pre_QC/
    mkdir ICOADS3/ICOADS_03_WM/
    mkdir ICOADS3/ICOADS_QCed/
    mkdir ICOADS3/ICOADS_Mis/
    
    mkdir ICOADSb
    mkdir ICOADSb/HM_SST_Bucket/
    mkdir ICOADSb/Miscellaneous/
    mkdir ICOADSb/HM_SST_Bucket/Step_01_Raw_Pairs/
    mkdir ICOADSb/HM_SST_Bucket/Step_02_Screen_Pairs
    mkdir ICOADSb/HM_SST_Bucket/Step_03_SUM_Pairs
    mkdir ICOADSb/HM_SST_Bucket/Step_04_run
    mkdir ICOADSb/HM_SST_Bucket/Step_05_corr_idv
    mkdir ICOADSb/HM_SST_Bucket/Step_06_corr_rnd
    
    cd(dir_code)
    dir_home_ICOADS3 = [dir_data,'ICOADS3/'];
    dir_home_ICOADSb = [dir_data,'ICOADSb/'];    
    save('chan_et_al_2019_directories.mat','dir_home_ICOADS3',...
         'dir_home_ICOADSb','dir_code','-v7.3');
    
end