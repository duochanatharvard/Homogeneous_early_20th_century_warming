% Input / Output management
%
% Last update: 2018-08-15

function output = ICOADS_OI(input)

    if strcmp(input,'home')
        load('chan_et_al_2019_directories.mat','dir_home_ICOADS3')
        output = dir_home_ICOADS3;

    elseif  strcmp(input,'raw_data')
        output = [ICOADS_OI('home'),'ICOADS_00_raw/'];

    elseif  strcmp(input,'mat_files')
        output = [ICOADS_OI('home'),'ICOADS_01_mat_files/'];

    elseif  strcmp(input,'pre_QC')
        output = [ICOADS_OI('home'),'ICOADS_02_pre_QC/'];

    elseif  strcmp(input,'WM')
        output = [ICOADS_OI('home'),'ICOADS_03_WM/'];

    elseif  strcmp(input,'QCed')
        output = [ICOADS_OI('home'),'ICOADS_QCed/'];

    elseif  strcmp(input,'Mis')
        output = [ICOADS_OI('home'),'ICOADS_Mis/'];
    end
end
