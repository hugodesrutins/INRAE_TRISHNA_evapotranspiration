%% Comparaison ETsimpKcET et ETR site de Fontblanche

% Authors :   Desrutins Hugo and Albert Olioso
% Company : INRAE Avignon
% Version :     February 2022 
% Last revision: February 2022
% Working coordinates 1 : N 43.915810, E 4.877200 (Avignon)
% Working coordinates 2 : N 43.240833, E 5.679166 (Fontblanche)

clc;
clearvars;
close all;

%% Load data

ETkC_FB = load('ETkC_Safran_FAO_daily.mat');
ETkC_FB = struct2array(ETkC_FB);
tmr =timerange("01-Jan-2017","01-Jan-2018");
ETkC_FB = ETkC_FB(tmr,:);

Measured_data_info = readtable('FBn_Meteo_L2C_daily.csv');
Measured_data = readmatrix('FBn_Meteo_L2C_daily.csv');
Measured_data_info(1,:) = [];

date = Measured_data_info.date_time;
date = string(date);
t = get_Time(date);

Measured_data_TT = array2timetable(Measured_data,'RowTimes',t,'VariableNames',Measured_data_info.Properties.VariableNames);
Measured_data_2017 = get_special_year(Measured_data_TT,"01-Jan-2017","31-Dec-2017");

norm_data_ETkc_Safran_FB = (ETkC_FB.ETkC - min(ETkC_FB.ETkC)) / ( max(ETkC_FB.ETkC) - min(ETkC_FB.ETkC));
norm_data_ET0_measure_FB = (Measured_data_2017.ETR - min(Measured_data_2017.ETR)) / ( max(Measured_data_2017.ETR) - min(Measured_data_2017.ETR));


%% Plot time series

figure(); % ETkc FB et ETR FB
ETr_measured_plot = plot(ETkC_FB.Time,Measured_data_2017.ETR,'DisplayName','Measured ET');
grid on;
title('Evapotranspiration réel mesuré et Evapotranspiration SimpKcET Fontblanche');
xlabel(' temps ');
ylabel(' mm/jour '); 
hold on;
ETkc_Safran_plot = plot(ETkC_FB.Time,ETkC_FB.ETkC,'DisplayName','ETkc Safran');
hold on;
legend([ETr_measured_plot, ETkc_Safran_plot]);

figure(); % Données normalisés ETR FB
norm_ETr_measure_plot = scatter(norm_data_ET0_measure_FB,norm_data_ETkc_Safran_FB,'DisplayName','Normalized comparaison ETr measure');
grid on;
title('Norm ETkc Fontblanche');
hold on ; 
norm_ETKC_Safran_plot =  scatter(norm_data_ETkc_Safran_FB,norm_data_ET0_measure_FB,'DisplayName','Normalized comparaison ETKc Safran');
x = [0:0.25:1];
y = x;
line_plot = plot(x, y);
legend([norm_ETr_measure_plot,norm_ETKC_Safran_plot]);


corr_coeff_ETkc_Safran_FB = corrcoef(Measured_data_2017.ETR,ETkC_FB.ETkC);
RMSE_Etkc_Safran_FB = sqrt(mean((ETkC_FB.ETkC-Measured_data_2017.ETR).^2,'omitnan'));
Bias_ETkC_Safran_FB = (sum(ETkC_FB.ETkC - Measured_data_2017.ETR)) / length(ETkC_FB.ETkC);

