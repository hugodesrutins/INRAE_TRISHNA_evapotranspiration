%% Evapotranspiration modelling with ERA5-land data

% Authors :   Desrutins Hugo and Albert Olioso
% Company : INRAE Avignon
% Version :     December 2021 
% Last revision: February 2022

clc;
clearvars;

%% Path Definition

addpath = 'D:\ERA5_data\ERA5_API\ERA5_API\ERA5_land_data_19502021';
nbr_mesure_daily = 24;
Lon_study_point = 5.6791; % Exemple point : Fontblanche, France
Lat_study_point = 43.2408;


%% Main fonction, see the function to get more details about input / output

tic % Execution time
[ET0_ERA5_TT,ET0_ERA5_FAO,ET0_ERA5_MF,tp_global] = ET0_Penman_Monteith_load_calc(addpath, nbr_mesure_daily,Lon_study_point,Lat_study_point);
toc % Execution time

%% Data formatting to export in SimpKcET model

tp_global = mean(tp_global);
tp_global = tp_global';
tp_TT = array2timetable(tp_global,'RowTimes',ET0_ERA5_TT.Time,'VariableNames',{'Total_precipitation'});

savepath = 'C:\Users\hdesrutins\Documents\INRAE\test\Matlab\SimpKcET';
savepath2 = 'C:\Users\hdesrutins\Documents\INRAE\test\Matlab\Test_Real_data';
savepath3 = 'C:\Users\hdesrutins\Documents\INRAE\test\Matlab\SAFRAN';
ET0_ERA5_TP = [ET0_ERA5_TT tp_TT];
save(fullfile(savepath,'ET0_ERA5_TT_Fontblanche'),'ET0_ERA5_TP');
save(fullfile(savepath2,'ET0_ERA5_TT_Fontblanche'),'ET0_ERA5_TP');
save(fullfile(savepath3,'ET0_ERA5_TT_Fontblanche'),'ET0_ERA5_TP');

 





