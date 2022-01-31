%% Evapotranspiration modelling with ERA5 data

% Authors :   Desrutins Hugo and Albert Olioso
% Company : INRAE Avignon
% Version :     December 2021 
% Last revision: February 2022

clc;
clear all;

%% Path Definition

addpath = 'D:\ERA5_data\ERA5_API\ERA5_API\ERA5_land_data_19502021';
nbr_mesure_daily = 24;


%% Main fonction, see the function to get more details about input / output

tic % Execution time
[ET0_ERA5_TT,ET0_ERA5_FAO,ET0_ERA5_MF,tp_global] = ET0_Penman_Monteith_load_calc(addpath, nbr_mesure_daily,4.8,43.9);
toc % Execution time

%% Data formatting to export in SimpKcET model

tp_global = mean(tp_global);
tp_global = tp_global';
tp_TT = array2timetable(tp_global,'RowTimes',ET0_ERA5_TT.Time,'VariableNames',{'Total_precipitation'});

savepath = 'C:\Users\hdesrutins\Documents\INRAE\test\Matlab\SimpKcET';
ET0_ERA5_TP = [ET0_ERA5_TT tp_TT];
save(fullfile(savepath,'ET0_ERA5_TT'),'ET0_ERA5_TP');


 





