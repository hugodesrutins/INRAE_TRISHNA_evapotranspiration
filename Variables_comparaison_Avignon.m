%% Comparaison Variables Era5 / Safran et Variables mesurées site d'Avignon

% Authors :   Desrutins Hugo and Albert Olioso
% Company : INRAE Avignon
% Version :     February 2022 
% Last revision: February 2022
% Working coordinates : N 43.915810, E 4.877200

clearvars;
clc;
close all;

%% Import Measured data temperature and TD data

Measured_temperature_data = xlsread('SFT_2017_meteo_L4_daily.xlsx'); % .csv contenant des données mesurées in-situ 
Measured_temperature_data([1:13],:) = [];
tmr = timerange('01-Jan-2017','01-Jan-2018'); % Test sur l'année 2018

ERA5_Data = load('ET0_ERA5_TT_Avignon.mat'); % ERA5 data
ERA5_Data = struct2array(ERA5_Data);
ERA5_Data = ERA5_Data(tmr,:);

Safran_Data = load('ET_variables_SAFRAN.mat'); % Safran data
Safran_Data = struct2array(Safran_Data);
Safran_Data = Safran_Data(tmr,:);

t1 = datetime(2017,01,1);
t2 = datetime(2017,12,31);
t = t1:t2; t = t';

%% Formatted data

Measured_Tair = Measured_temperature_data(:,2);
Measured_Tmin = Measured_temperature_data(:,3);
Measured_Tmax = Measured_temperature_data(:,4);
Measured_TP = Measured_temperature_data(:,17);
Measured_wind = Measured_temperature_data(:,11);
Measured_Var = [Measured_Tair Measured_Tmin Measured_Tmax Measured_TP Measured_wind];
varnames = {'Tair','Tmin','Tmax','Tp','wind_mean'};

Measured_Var_TT = array2timetable(Measured_Var,'RowTimes',t,'VariableNames',varnames);


%% Normalize data

norm_data_Tair_Safran = (Safran_Data.Tair_Safran - min(Safran_Data.Tair_Safran)) / ( max(Safran_Data.Tair_Safran) - min(Safran_Data.Tair_Safran));
norm_data_Tair_measure = (Measured_Var_TT.Tair - min(Measured_Var_TT.Tair)) / ( max(Measured_Var_TT.Tair) - min(Measured_Var_TT.Tair));
norm_data_Tair_Era5 = (ERA5_Data.T_moy - min(ERA5_Data.T_moy)) / ( max(ERA5_Data.T_moy) - min(ERA5_Data.T_moy));

norm_data_Tmin_Safran = (Safran_Data.Tmin_Safran - min(Safran_Data.Tmin_Safran)) / ( max(Safran_Data.Tmin_Safran) - min(Safran_Data.Tmin_Safran));
norm_data_Tmin_measure = (Measured_Var_TT.Tmin - min(Measured_Var_TT.Tmin)) / ( max(Measured_Var_TT.Tmin) - min(Measured_Var_TT.Tmin));
norm_data_Tmin_Era5 = (ERA5_Data.T_min - min(ERA5_Data.T_min)) / ( max(ERA5_Data.T_min) - min(ERA5_Data.T_min));

norm_data_Tmax_Safran = (Safran_Data.Tmax_Safran - min(Safran_Data.Tmax_Safran)) / ( max(Safran_Data.Tmax_Safran) - min(Safran_Data.Tmax_Safran));
norm_data_Tmax_measure = (Measured_Var_TT.Tmax - min(Measured_Var_TT.Tmax)) / ( max(Measured_Var_TT.Tmax) - min(Measured_Var_TT.Tmax));
norm_data_Tmax_Era5 = (ERA5_Data.T_max - min(ERA5_Data.T_max)) / ( max(ERA5_Data.T_max) - min(ERA5_Data.T_max));

norm_data_Wind_measure = (Measured_Var_TT.wind_mean - min(Measured_Var_TT.wind_mean)) / ( max(Measured_Var_TT.wind_mean) - min(Measured_Var_TT.wind_mean));
norm_data_Wind_Safran =  (Safran_Data.wind_Safran - min(Safran_Data.wind_Safran)) / ( max(Safran_Data.wind_Safran) - min(Safran_Data.wind_Safran));
norm_data_Wind_Era5 =  (ERA5_Data.("Wind speed") - min(ERA5_Data.("Wind speed"))) / ( max(ERA5_Data.("Wind speed")) - min(ERA5_Data.("Wind speed")));

norm_data_Tp_measure = (Measured_Var_TT.Tp - min(Measured_Var_TT.Tp)) / ( max(Measured_Var_TT.Tp) - min(Measured_Var_TT.Tp));
norm_data_Tp_Safran =  (Safran_Data.Tp_Safran - min(Safran_Data.Tp_Safran)) / ( max(Safran_Data.Tp_Safran) - min(Safran_Data.Tp_Safran));
norm_data_Tp_Era5 =  (ERA5_Data.Total_precipitation - min(ERA5_Data.Total_precipitation)) / ( max(ERA5_Data.Total_precipitation) - min(ERA5_Data.Total_precipitation));

%% Comparaison

figure(); % Tair mesuré et Tair Safran
Tair_measured_plot = plot(Safran_Data.Time,Measured_Var_TT.Tair,'DisplayName','Measured Tair');
grid on;
title('Comparaison Tair Safran');
xlabel(' temps ');
ylabel(' °C'); 
hold on;
Tair_Safran_plot = plot(Safran_Data.Time,Safran_Data.Tair_Safran,'DisplayName','Tair Safran');
legend([Tair_measured_plot, Tair_Safran_plot]);

Corr_coef_Tair_Safran = corrcoef(Measured_Var_TT.Tair,Safran_Data.Tair_Safran,'Rows','complete');

figure(); % Tair mesuré et Tair Era5
Tair_measured_plot = plot(Safran_Data.Time,Measured_Var_TT.Tair,'DisplayName','Measured Tair');
grid on;
title('Comparaison Tair Era5');
xlabel(' temps ');
ylabel(' °C'); 
hold on;
Tair_Era5_plot = plot(Safran_Data.Time,ERA5_Data.T_moy,'DisplayName','Tair Era5');
legend([Tair_measured_plot, Tair_Era5_plot]);

figure(); % Données normalisés Tair Safran
norm_Tair_measure_plot = scatter(norm_data_Tair_measure,norm_data_Tair_Safran,'DisplayName','Normalized comparaison Tair Measured');
grid on;
title('Norm Tair Safran');
hold on ; 
norm_Tair_Safran_plot =  scatter(norm_data_Tair_Safran,norm_data_Tair_measure,'DisplayName','Normalized comparaison Tair Safran');
x = [0:0.25:1];
y = x;
line_plot = plot(x, y);
legend([norm_Tair_measure_plot,norm_Tair_Safran_plot]);

figure(); % Données normalisés Tair Era5
norm_Tair_measure_plot = scatter(norm_data_Tair_measure,norm_data_Tair_Era5,'DisplayName','Normalized comparaison Tair Measured');
grid on;
title('Norm Tair Era5 land');
hold on ; 
norm_Tair_Era5_plot =  scatter(norm_data_Tair_Era5,norm_data_Tair_measure,'DisplayName','Normalized comparaison Tair Era5 land');
x = [0:0.25:1];
y = x;
line_plot = plot(x, y);
legend([norm_Tair_measure_plot,norm_Tair_Era5_plot]);

Corr_coef_Tair_Era5 = corrcoef(Measured_Var_TT.Tair,ERA5_Data.T_moy,'Rows','complete');

figure(); % Tmin mesuré et Tmin Safran
Tmin_measured_plot = plot(Safran_Data.Time,Measured_Var_TT.Tmin,'DisplayName','Measured Tmin');
grid on;
title('Comparaison Tmin Safran');
xlabel(' temps ');
ylabel(' °C'); 
hold on;
Tmin_Safran_plot = plot(Safran_Data.Time,Safran_Data.Tmin_Safran,'DisplayName','Tmin Safran');
legend([Tmin_measured_plot, Tmin_Safran_plot]);

figure(); % Données normalisés Tmin Safran
norm_Tmin_measure_plot = scatter(norm_data_Tmin_measure,norm_data_Tmin_Safran,'DisplayName','Normalized comparaison Tmin Measured');
grid on;
title('Norm min Safran ');
hold on ; 
norm_Tair_Safran_plot =  scatter(norm_data_Tmin_Safran,norm_data_Tmin_measure,'DisplayName','Normalized comparaison Tmin Safran');
x = [0:0.25:1];
y = x;
line_plot = plot(x, y);
legend([norm_Tair_measure_plot,norm_Tair_Safran_plot]);

figure(); % Tmin mesuré et Tmin Era5
Tmin_measured_plot = plot(Safran_Data.Time,Measured_Var_TT.Tmin,'DisplayName','Measured Tmin');
grid on;
title('Comparaison Tmin Era5');
xlabel(' temps ');
ylabel(' °C'); 
hold on;
Tmin_Era5_plot = plot(Safran_Data.Time,ERA5_Data.T_min,'DisplayName','Tmin Era5');
legend([Tmin_measured_plot, Tmin_Era5_plot]);

figure(); % Données normalisés Tmin Era5
norm_Tmin_measure_plot = scatter(norm_data_Tmin_measure,norm_data_Tmin_Era5,'DisplayName','Normalized comparaison Tmin Measured');
grid on;
title('Norm min Era5 land ');
hold on ; 
norm_Tair_Era5_plot =  scatter(norm_data_Tmin_Era5,norm_data_Tmin_measure,'DisplayName','Normalized comparaison Tmin Era5 land');
x = [0:0.25:1];
y = x;
line_plot = plot(x, y);
legend([norm_Tair_measure_plot,norm_Tair_Era5_plot]);


figure(); % Tmax mesuré et Tmax Safran
Tmax_measured_plot = plot(Safran_Data.Time,Measured_Var_TT.Tmax,'DisplayName','Measured Tmax');
grid on;
title('Comparaison Tmax Safran');
xlabel(' temps ');
ylabel(' °C'); 
hold on;
Tmax_Safran_plot = plot(Safran_Data.Time,Safran_Data.Tmax_Safran,'DisplayName','Tmax Safran');
legend([Tmax_measured_plot, Tmax_Safran_plot]);

figure(); % Données normalisés Tmax Safran
norm_Tmax_measure_plot = scatter(norm_data_Tmax_measure,norm_data_Tmax_Safran,'DisplayName','Normalized comparaison Tmax Measured');
grid on;
title('Norm max Safran ');
hold on ; 
norm_Tmax_Safran_plot =  scatter(norm_data_Tmax_Safran,norm_data_Tmax_measure,'DisplayName','Normalized comparaison Tmax Safran');
x = [0:0.25:1];
y = x;
line_plot = plot(x, y);
legend([norm_Tmax_measure_plot,norm_Tmax_Safran_plot]);

figure(); % Tmax mesuré et Tmax Era5
Tmax_measured_plot = plot(Safran_Data.Time,Measured_Var_TT.Tmax,'DisplayName','Measured Tmax');
grid on;
title('Comparaison Tmax Era5');
xlabel(' temps ');
ylabel(' °C'); 
hold on;
Tmax_Era5_plot = plot(Safran_Data.Time,ERA5_Data.T_max,'DisplayName','Tmax Era5');
legend([Tmax_measured_plot, Tmax_Era5_plot]);

figure(); % Données normalisés Tmax Era5
norm_Tmax_measure_plot = scatter(norm_data_Tmax_measure,norm_data_Tmax_Era5,'DisplayName','Normalized comparaison Tmax Measured');
grid on;
title('Norm max Era5 ');
hold on ; 
norm_Tmax_Era5_plot =  scatter(norm_data_Tmax_Era5,norm_data_Tmax_measure,'DisplayName','Normalized comparaison Tmax Era5');
x = [0:0.25:1];
y = x;
line_plot = plot(x, y);
legend([norm_Tmax_measure_plot,norm_Tmax_Era5_plot]);

figure(); % Precipitation mesurées et Safran
Tp_measured_plot = plot(Safran_Data.Time,Measured_Var_TT.Tp,'DisplayName','Measured Tp');
grid on;
title('Comparaison Tp Safran');
xlabel(' temps ');
ylabel(' mm'); 
hold on;
Tp_Safran_plot = plot(Safran_Data.Time,Safran_Data.Tp_Safran,'DisplayName','Tp Safran');
legend([Tp_measured_plot, Tp_Safran_plot]);

figure(); % Données normalisés Tp Safran
norm_Tp_Safran_plot = scatter(norm_data_Tp_Safran,norm_data_Tp_measure,'DisplayName','Normalized comparaison Tp Safran');
grid on;
title('Precipitation Safran');
hold on ; 
x = [0:0.25:1];
y = x;
line_plot = plot(x, y);
legend([norm_Tp_Safran_plot]);

figure(); % Precipitation mesurées et Era5
Tp_measured_plot = plot(Safran_Data.Time,Measured_Var_TT.Tp,'DisplayName','Measured Tp');
grid on;
title('Comparaison Tp Era5');
xlabel(' temps ');
ylabel(' mm'); 
hold on;
Tp_Era5_plot = plot(Safran_Data.Time,ERA5_Data.Total_precipitation,'DisplayName','Tp Era5');
legend([Tp_measured_plot, Tp_Era5_plot]);

figure(); % Données normalisés Tp Era5
norm_Tp_Era5_plot = scatter(norm_data_Tp_Era5,norm_data_Tp_measure,'DisplayName','Normalized comparaison Tp Era5');
grid on;
title('Precipitation Era5');
hold on ; 
x = [0:0.25:1];
y = x;
line_plot = plot(x, y);
legend([norm_Tp_Era5_plot]);

figure(); % Vent_moyen mesurées et vent Safran
Wind_measured_plot = plot(Safran_Data.Time,(Measured_Var_TT.wind_mean)/3.6,'DisplayName','Measured Wind');
grid on;
title('Comparaison Wind Safran');
xlabel(' temps ');
ylabel(' m/s'); 
hold on;
Wind_Safran_plot = plot(Safran_Data.Time,Safran_Data.wind_Safran,'DisplayName','Wind Safran');
legend([Wind_measured_plot, Wind_Safran_plot]);

figure(); % Vent_moyen mesurées et vent Era5
Wind_measured_plot = plot(Safran_Data.Time,(Measured_Var_TT.wind_mean)/3.6,'DisplayName','Measured Wind');
grid on;
title('Comparaison Wind Era5');
xlabel(' temps ');
ylabel(' m/s'); 
hold on;
Wind_Era5_plot = plot(Safran_Data.Time,ERA5_Data.("Wind speed"),'DisplayName','Wind Era5');
legend([Wind_measured_plot, Wind_Era5_plot]);

figure(); % Données normalisés Wind Safran
norm_Wind_Measure_plot = scatter(norm_data_Wind_measure,norm_data_Wind_Safran,'DisplayName','Normalized comparaison Wind Measured');
grid on;
title('Norm Wind Safran');
hold on ; 
norm_Wind_Safran_plot = scatter(norm_data_Wind_Safran,norm_data_Wind_measure,'DisplayName','Normalized comparaison Wind Safran');
x = [0:0.25:1];
y = x;
line_plot = plot(x, y);
legend([norm_Wind_Measure_plot,norm_Wind_Safran_plot]);

figure(); % Données normalisés Wind Safran
norm_Wind_Measure_plot = scatter(norm_data_Wind_measure,norm_data_Wind_Era5,'DisplayName','Normalized comparaison Wind Measured');
grid on;
title('Norm Wind Era5 land');
hold on ; 
norm_Wind_Era5_plot = scatter(norm_data_Wind_Era5,norm_data_Wind_measure,'DisplayName','Normalized comparaison Wind Era5 land');
x = [0:0.25:1];
y = x;
line_plot = plot(x, y);
legend([norm_Wind_Measure_plot,norm_Wind_Era5_plot]);




