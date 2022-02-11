%% Comparaison ET0 Era5 / Safran et ET0 mesurées site d'Avignon et Fontblanche

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

 tmr = timerange('01-Jan-2018','01-Jan-2019');
 tmr2 = timerange('01-Jan-2017','01-Jan-2018');

Measured_data_Av = xlsread('SFT_2018_meteo_L4_daily.xlsx'); % .csv contenant des données mesurées in-situ Avignon 2018
Measured_data_Av([1:13],:) = [];

Measured_data_info = readtable('FBn_Meteo_L2C_daily.csv'); % .csv contenant des données mesurées in-situ Fontblanche
Measured_data_FB = readmatrix('FBn_Meteo_L2C_daily.csv');
Measured_data_info(1,:) = [];

date = Measured_data_info.date_time;
date = string(date);
t = get_Time(date);

Measured_data_TT_FB = array2timetable(Measured_data_FB,'RowTimes',t,'VariableNames',Measured_data_info.Properties.VariableNames);
Measured_data_TT_FB = get_special_year(Measured_data_TT_FB,"01-Jan-2017","31-Dec-2017");

ERA5_Data_Avignon = load('ET0_ERA5_TT_Avignon.mat'); % ERA5 data Avignon
ERA5_Data_Avignon = struct2array(ERA5_Data_Avignon);
ERA5_Data_Avignon = ERA5_Data_Avignon(tmr,:);

ERA5_Data_Fontblanche = load('ET0_ERA5_TT_Fontblanche.mat'); % ERA5 data FB
ERA5_Data_Fontblanche = struct2array(ERA5_Data_Fontblanche);
ERA5_Data_Fontblanche = ERA5_Data_Fontblanche(tmr2,:);

Safran_Data_Avignon = load('ET_variables_SAFRAN.mat'); % Safran data Avignon
Safran_Data_Avignon = struct2array(Safran_Data_Avignon);
Safran_Data_Avignon = Safran_Data_Avignon(tmr,:);

Safran_Data_Fontblanche = load('ET_variables_SAFRAN_Fontblanche.mat'); % Safran data FB
Safran_Data_Fontblanche = struct2array(Safran_Data_Fontblanche);
Safran_Data_Fontblanche = Safran_Data_Fontblanche(tmr2,:);

%% Formatted data

norm_data_ET0_Safran_Avignon = (Safran_Data_Avignon.ET0_SAFRAN_FAO - min(Safran_Data_Avignon.ET0_SAFRAN_FAO)) / ( max(Safran_Data_Avignon.ET0_SAFRAN_FAO) - min(Safran_Data_Avignon.ET0_SAFRAN_FAO));
norm_data_ET0_measure_Avignon = (Measured_data_Av(:,19) - min(Measured_data_Av(:,19))) / ( max(Measured_data_Av(:,19)) - min(Measured_data_Av(:,19)));
norm_data_ET0_Era5_Avignon = (ERA5_Data_Avignon.ET0_ERA5_FAO_daily- min(ERA5_Data_Avignon.ET0_ERA5_FAO_daily)) / ( max(ERA5_Data_Avignon.ET0_ERA5_FAO_daily) - min(ERA5_Data_Avignon.ET0_ERA5_FAO_daily));

norm_data_ET0_Safran_Fontblanche = (Safran_Data_Fontblanche.ET0_SAFRAN_FAO - min(Safran_Data_Fontblanche.ET0_SAFRAN_FAO)) / ( max(Safran_Data_Fontblanche.ET0_SAFRAN_FAO) - min(Safran_Data_Fontblanche.ET0_SAFRAN_FAO));
norm_data_ET0_measure_Fontblanche = (Measured_data_TT_FB.ETP - min(Measured_data_TT_FB.ETP)) / ( max(Measured_data_TT_FB.ETP) - min(Measured_data_TT_FB.ETP));
norm_data_ET0_Era5_Fontblanche = (ERA5_Data_Fontblanche.ET0_ERA5_FAO_daily- min(ERA5_Data_Fontblanche.ET0_ERA5_FAO_daily)) / ( max(ERA5_Data_Fontblanche.ET0_ERA5_FAO_daily) - min(ERA5_Data_Fontblanche.ET0_ERA5_FAO_daily));



%% Comparaison ET0 SAFRAN / ERA5 LAND / ET0 mesuré in situ


figure(); % Données normalisés ET0 Avignon
norm_ET0_measure_plot = scatter(norm_data_ET0_measure_Avignon,norm_data_ET0_Safran_Avignon,'DisplayName','Normalized comparaison ET0 measure');
grid on;
title('Norm ET0 Avignon');
hold on ; 
norm_ET0_Safran_plot =  scatter(norm_data_ET0_Safran_Avignon,norm_data_ET0_measure_Avignon,'DisplayName','Normalized comparaison ET0 Safran');
hold on;
norm_ET0_Era5_plot =  scatter(norm_data_ET0_Era5_Avignon,norm_data_ET0_measure_Avignon,'DisplayName','Normalized comparaison ET0 Era5');
x = [0:0.25:1];
y = x;
line_plot = plot(x, y);
legend([norm_ET0_measure_plot,norm_ET0_Safran_plot,norm_ET0_Era5_plot]);

figure(); % ET0 Safran , ETO ERA5, ET0 mesuré 2 FAO méthod Avignon
ET0_measured_plot = plot(ERA5_Data_Avignon.Time,Measured_data_Av(:,19),'DisplayName','Measured ET0');
grid on;
title('Evapotranspiration mesuré et Evapotranspiration Era5 land / Safran Avignon');
xlabel(' temps ');
ylabel(' ET0(mm/jour) '); 
hold on;
ET0_Safran_plot = plot(Safran_Data_Avignon.Time,Safran_Data_Avignon.ET0_SAFRAN_FAO,'DisplayName','ET0 Safran FAO');
hold on;
ET0_ERA5_plot = plot(ERA5_Data_Avignon.Time,ERA5_Data_Avignon.ET0_ERA5_FAO_daily,'DisplayName','ET0 ERA5land FAO');
legend([ET0_measured_plot, ET0_Safran_plot, ET0_ERA5_plot]);

figure(); % ET0 Safran , ETO ERA5, ET0 mesuré 2 FAO méthod Fontblanche
ET0_measured_plot = plot(ERA5_Data_Fontblanche.Time,Measured_data_TT_FB.ETP,'DisplayName','Measured ET0');
grid on;
title('Evapotranspiration mesuré et Evapotranspiration Era5 land / Safran Fontblanche');
xlabel(' temps ');
ylabel(' ET0(mm/jour) '); 
hold on;
ET0_Safran_plot = plot(Safran_Data_Fontblanche.Time,Safran_Data_Fontblanche.ET0_SAFRAN_FAO,'DisplayName','ET0 Safran FAO');
hold on;
ET0_ERA5_plot = plot(ERA5_Data_Fontblanche.Time,ERA5_Data_Fontblanche.ET0_ERA5_FAO_daily,'DisplayName','ET0 ERA5land FAO');
legend([ET0_measured_plot, ET0_Safran_plot, ET0_ERA5_plot]);

figure(); % Données normalisés ET0 Fontblanche
norm_ET0_measure_plot = scatter(norm_data_ET0_measure_Fontblanche,norm_data_ET0_Safran_Fontblanche,'DisplayName','Normalized comparaison ET0 measure');
grid on;
title('Norm ET0 Fontblanche');
hold on ; 
norm_ET0_Safran_plot =  scatter(norm_data_ET0_Safran_Fontblanche,norm_data_ET0_measure_Fontblanche,'DisplayName','Normalized comparaison ET0 Safran');
hold on;
norm_ET0_Era5_plot =  scatter(norm_data_ET0_Era5_Fontblanche,norm_data_ET0_measure_Fontblanche,'DisplayName','Normalized comparaison ET0 Era5');
x = [0:0.25:1];
y = x;
line_plot = plot(x, y);
legend([norm_ET0_measure_plot,norm_ET0_Safran_plot,norm_ET0_Era5_plot]);

%% Comparaison ET0 ERA5 land et Safran

figure(); % ET0 Safran , ETO ERA5 FAO méthod Avignon
ET0_ERA5_plot = plot(ERA5_Data_Avignon.Time,ERA5_Data_Avignon.ET0_ERA5_FAO_daily,'DisplayName','ET0 ERA5land FAO');;
grid on;
title('Evapotranspiration Era5 land / Safran Avignon');
xlabel(' temps ');
ylabel(' ET0(mm/jour) '); 
hold on;
ET0_Safran_plot = plot(Safran_Data_Avignon.Time,Safran_Data_Avignon.ET0_SAFRAN_FAO,'DisplayName','ET0 Safran FAO');
legend([ET0_Safran_plot, ET0_ERA5_plot]);

figure(); % Données normalisés ET0 Avignon
norm_ET0_Era5_plot =  scatter(norm_data_ET0_Era5_Avignon,norm_data_ET0_measure_Avignon,'DisplayName','Normalized comparaison ET0 Era5');
grid on;
title('Norm Avignon');
hold on ; 
norm_ET0_Safran_plot =  scatter(norm_data_ET0_Safran_Avignon,norm_data_ET0_measure_Avignon,'DisplayName','Normalized comparaison ET0 Safran');
x = [0:0.25:1];
y = x;
line_plot = plot(x, y);
legend([norm_ET0_Safran_plot,norm_ET0_Era5_plot]);

figure(); % ET0 Safran , ETO ERA5 FAO méthod Avignon
ET0_ERA5_plot = plot(ERA5_Data_Fontblanche.Time,ERA5_Data_Fontblanche.ET0_ERA5_FAO_daily,'DisplayName','ET0 ERA5land FAO');;
grid on;
title('Evapotranspiration Era5 land / Safran Fontblanche');
xlabel(' temps ');
ylabel(' ET0(mm/jour) '); 
hold on;
ET0_Safran_plot = plot(Safran_Data_Fontblanche.Time,Safran_Data_Fontblanche.ET0_SAFRAN_FAO,'DisplayName','ET0 Safran FAO');
legend([ET0_Safran_plot, ET0_ERA5_plot]);

figure(); % Données normalisés ET0 FB
norm_ET0_Era5_plot =  scatter(norm_data_ET0_Era5_Fontblanche,norm_data_ET0_measure_Fontblanche,'DisplayName','Normalized comparaison ET0 Era5');
grid on;
title('Norm FB');
hold on ; 
norm_ET0_Safran_plot =  scatter(norm_data_ET0_Safran_Fontblanche,norm_data_ET0_measure_Fontblanche,'DisplayName','Normalized comparaison ET0 Safran');
x = [0:0.25:1];
y = x;
line_plot = plot(x, y);
legend([norm_ET0_Safran_plot,norm_ET0_Era5_plot]);



%% Coefficient

corr_coeff_ETO_ERA5_Avignon = corrcoef(Measured_data_Av(:,19),ERA5_Data_Avignon.ET0_ERA5_FAO_daily);
corr_coeff_ETO_Safran_Avignon = corrcoef(Measured_data_Av(:,19),Safran_Data_Avignon.ET0_SAFRAN_FAO);
corr_coeff_ETO_Safran_Era5_Avignon = corrcoef(ERA5_Data_Avignon.ET0_ERA5_FAO_daily,Safran_Data_Avignon.ET0_SAFRAN_FAO);
RMSE_ET0_ERA5_Avignon = sqrt(mean((ERA5_Data_Avignon.ET0_ERA5_FAO_daily-Measured_data_Av(:,19)).^2,'omitnan'));
RMSE_ET0_Safran_Avignon = sqrt(mean((Safran_Data_Avignon.ET0_SAFRAN_FAO-Measured_data_Av(:,19)).^2,'omitnan'));
RMSE_ET0_ERA5_Safran_Avignon = sqrt(mean((ERA5_Data_Avignon.ET0_ERA5_FAO_daily - Safran_Data_Avignon.ET0_SAFRAN_FAO).^2,'omitnan'));
Bias_ET0_ERA5_Avignon = (sum(ERA5_Data_Avignon.ET0_ERA5_FAO_daily - Measured_data_Av(:,19))) / length(ERA5_Data_Avignon.ET0_ERA5_FAO_daily);
Bias_ET0_Safran_Avignon = (sum(Safran_Data_Avignon.ET0_SAFRAN_FAO - Measured_data_Av(:,19))) / length(Safran_Data_Avignon.ET0_SAFRAN_FAO);
corr_coeff_ETO_ERA5_FB = corrcoef(Measured_data_TT_FB.ETP,ERA5_Data_Fontblanche.ET0_ERA5_FAO_daily);
corr_coeff_ETO_Safran_FB = corrcoef(Measured_data_TT_FB.ETP,Safran_Data_Fontblanche.ET0_SAFRAN_FAO);
corr_coeff_ETO_Safran_Era5_FB = corrcoef(ERA5_Data_Fontblanche.ET0_ERA5_FAO_daily,Safran_Data_Fontblanche.ET0_SAFRAN_FAO);
RMSE_ET0_ERA5_FB = sqrt(mean((ERA5_Data_Fontblanche.ET0_ERA5_FAO_daily-Measured_data_TT_FB.ETP).^2,'omitnan'));
RMSE_ET0_Safran_FB = sqrt(mean((Safran_Data_Fontblanche.ET0_SAFRAN_FAO-Measured_data_TT_FB.ETP).^2,'omitnan'));
Bias_ET0_ERA5_FB = (sum(ERA5_Data_Fontblanche.ET0_ERA5_FAO_daily - Measured_data_TT_FB.ETP)) / length(ERA5_Data_Fontblanche.ET0_ERA5_FAO_daily);
Bias_ET0_Safran_FB = (sum(Safran_Data_Fontblanche.ET0_SAFRAN_FAO - Measured_data_TT_FB.ETP)) / length(Safran_Data_Fontblanche.ET0_SAFRAN_FAO);
Bias_ET0_Era5_Safran_Avignon = (sum(Safran_Data_Avignon.ET0_SAFRAN_FAO - ERA5_Data_Avignon.ET0_ERA5_FAO_daily)) / length(Safran_Data_Avignon.ET0_SAFRAN_FAO);
