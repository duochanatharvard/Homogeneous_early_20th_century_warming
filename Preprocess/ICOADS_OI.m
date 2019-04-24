% Input / Output management
%
% Last update: 2018-08-15

function output = ICOADS_OI(input)

    if strcmp(input,'home')
        % ################################################################
        % ################################################################
        % ################################################################
        % Set the home directory, should be where the data are saved
        output = ; % TODO  directory of ICOADS3.0 data, environment 1
                   % Make sure this is consistent with line 40 in HM_OI.m
        % ################################################################
        % ################################################################
        % ################################################################

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
