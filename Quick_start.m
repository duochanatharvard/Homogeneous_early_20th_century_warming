HM_load_package;
clear; clc; close all;

tic;
varname = 'SST';
method  = 'Bucket';

% *************************************************************************
% Below are parameters used to reproduce results reported in the main text
% *************************************************************************
do_NpD = 1;                     % Use nation-deck groups
app_exp = 'cor_err';            % Model as in Chan and Huybers (2019)
EP.do_rmdup = 0;                % Do not remove DUPS != 0
EP.do_rmsml = 0;                % Do not remove small groups
EP.sens_id  = 0;                % Use 5-year and 17-region binning
EP.do_fewer_first = 0;          % Priority in pair screening: distance
EP.connect_kobe   = 1;          % Combine Kobe collection decks
EP.do_add_JP = 0;               % Correct JPKB truancation before LME
EP.yr_start = 1850;             % Staring year of the first 5-year bin
EP.do_focus = 1;                % Figure 1 focus on 1908-1941

% *************************************************************************
% Generate Table 1
% *************************************************************************
clearvars -except varname method do_NpD app_exp EP
HM_STATS_SST;

% *************************************************************************
% Generate Offsets for individual groups reported in the main text
% *************************************************************************
clearvars -except varname method do_NpD app_exp EP
HM_STATS_LME;

% *************************************************************************
% Generate Figure 1
% *************************************************************************
clearvars -except varname method do_NpD app_exp EP
disp(['Plotting figure 1 ...'])
disp([' '])
HM_Fig_1;

% *************************************************************************
% Generate Figure 2
% *************************************************************************
clearvars -except varname method do_NpD app_exp EP
disp(['Plotting figure 2 ...'])
disp([' '])
HM_Fig_2;

% *************************************************************************
% Generate Figure 3
% *************************************************************************
clearvars -except varname method do_NpD app_exp EP
disp(['Plotting figure 3 ...'])
disp([' '])
HM_Fig_3;

% *************************************************************************
% Generate Figure 4
% *************************************************************************
clearvars -except varname method do_NpD app_exp EP
disp(['Plotting figure 4 ...'])
disp([' '])
HM_Fig_4;

disp(['Quick start takes ',num2str(toc,'%6.0f'),' seconds'])