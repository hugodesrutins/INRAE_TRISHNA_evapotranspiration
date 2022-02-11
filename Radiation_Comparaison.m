%% Comparaison RN Télédétection et RN mesuré Site d'avignon

clearvars;
clc;
close all;

%% Import Measured data Radiation and TD data

Measured_Radiation_info = readtable('SFT_2018_radiation_L2.csv');
Measured_Radiation_info([1:2],:) = [];
date = Measured_Radiation_info.DateTime;
date = string(date);
t = get_Time(date);
Measured_Radiation = readmatrix('SFT_2018_radiation_L2.csv');

Measured_data_TT = array2timetable(Measured_Radiation,'RowTimes',t,'VariableNames',Measured_Radiation_info.Properties.VariableNames);
Measured_data_TT_retime = retime(Measured_data_TT,'daily','sum');

tmr = timerange("01-Jan-2018","01-Jan-2019");

ERA5_land_data = load('ET0_ERA5_TT.mat');
ERA5_land_data = struct2array(ERA5_land_data);
ERA5_land_data = ERA5_land_data(tmr,:);

Era5_Rad_data = load('Rad_ERA5_test.mat');
Era5_Rad_data = struct2array(Era5_Rad_data);

Era5_SL_rad_data = load('Rad_ERA5_single_levels_test.mat');
Era5_SL_rad_data = struct2array(Era5_SL_rad_data);

Ra_ERA5 = Era5_Rad_data.Ra_Era5 *2;
Rs_ERA5 = Era5_Rad_data.Rs_Era5 *2;

Safran_Data = load('ET_variables_SAFRAN.mat');
Safran_Data = struct2array(Safran_Data);
Safran_Data = Safran_Data(tmr,:);




%% Formatted data

Rs1 = (Measured_data_TT_retime.ShortWaveIncomingRadiation)/48;
Rs1 = Rs1/(1000000/86400);
err_Rs1 = find(Rs1 < 0);
err2_Rs1 = find(Rs1 == 1.1597);
Rs1(err_Rs1) = NaN;
Rs1(164) = NaN;

Ra1 = (Measured_data_TT_retime.LongWaveIncomingRadiation)/48;
Ra1 = Ra1/(1000000/86000);
err_Ra1 = find(Ra1 < 0);
Ra1(err_Ra1) = NaN;

Radiation = [Ra_ERA5, Rs_ERA5, Safran_Data.Ra_Safran, Safran_Data.Rs_Safran,Ra1,Rs1];
varnames = {'Ra_ERA5_land','Rs_ERA5_land','Ra_SAFRAN','Rs_SAFRAN','Ra_measured','Rs_measured'};
Radiation_2018_TT = array2timetable(Radiation,'RowTimes',Safran_Data.Time,'VariableNames',varnames);
% writetimetable(Radiation_2018_TT,'Radiation_2018.csv','Delimiter',';');


norm_data_Ra_Safran = (Safran_Data.Ra_Safran - min(Safran_Data.Ra_Safran)) / ( max(Safran_Data.Ra_Safran) - min(Safran_Data.Ra_Safran));
norm_data_Rs_Safran = (Safran_Data.Rs_Safran - min(Safran_Data.Rs_Safran)) / ( max(Safran_Data.Rs_Safran) - min(Safran_Data.Rs_Safran));
norm_data_Rs_measure = (Rs1 - min(Rs1)) / ( max(Rs1) - min(Rs1));
norm_data_Ra_measure = (Ra1 - min(Ra1)) / ( max(Ra1) - min(Ra1));
norm_data_Rs_ERA5 = (Rs_ERA5 - min(Rs_ERA5)) / ( max(Rs_ERA5) - min(Rs_ERA5));
norm_data_Ra_ERA5 = (Ra_ERA5 - min(Ra_ERA5)) / ( max(Ra_ERA5) - min(Ra_ERA5));


%% Comparaison

figure(); % Radiation longwave mesuré et Ra Safran
Ra_measured_plot = plot(Safran_Data.Time,Ra1,'DisplayName','Measured Ra');
grid on;
title('Comparaison Ra mesuré / Safran');
xlabel(' temps ');
ylabel(' MJ/m²'); 
hold on;
Rs_Safran_plot = plot(Safran_Data.Time,Safran_Data.Ra_Safran,'DisplayName','Ra Safran');
legend([Ra_measured_plot, Rs_Safran_plot]);

figure(); % Données normalisés Ra
norm_Ra_measure_plot = scatter(norm_data_Ra_Safran,norm_data_Ra_measure,'DisplayName','Normalized comparaison Ra Measure');
grid on;
title('Norm Ra Safran');
hold on ; 
norm_Ra_Safran_plot = scatter(norm_data_Ra_measure,norm_data_Ra_Safran,'DisplayName','Normalized comparaison Ra Safran');
hold on;
x = [0:0.25:1];
y = x;
line_plot = plot(x, y);
legend([norm_Ra_measure_plot,norm_Ra_Safran_plot]);

Corr_coef_Rs_Safran = corrcoef(Rs1,Safran_Data.Rs_Safran,'Rows','complete');
RMSE_Rs_Safran = sqrt(mean((Rs1-Safran_Data.Rs_Safran).^2,'omitnan'));

figure(); % Radiation shortwave mesuré et Rs Safran
Rs_measured_plot = plot(Safran_Data.Time,Rs1,'DisplayName','Measured Rs');
grid on;
title('Comparaison Rs Safran');
xlabel(' temps ');
ylabel(' MJ/m²'); 
hold on;
Rs_Safran_plot = plot(Safran_Data.Time,Safran_Data.Rs_Safran,'DisplayName','Rs Safran');
legend([Rs_measured_plot, Rs_Safran_plot]);

figure(); % Données normalisés Rs
norm_Rs_measure_plot = scatter(norm_data_Rs_Safran,norm_data_Rs_measure,'DisplayName','Normalized comparaison Rs Measure');
grid on;
title('Norm Rs Safran');
hold on ; 
norm_Rs_Safran_plot = scatter(norm_data_Rs_measure,norm_data_Rs_Safran,'DisplayName','Normalized comparaison Rs Safran');
hold on;
x = [0:0.25:1];
y = x;
line_plot = plot(x, y);
legend([norm_Rs_measure_plot,norm_Rs_Safran_plot]);


Corr_coef_Ra_Safran = corrcoef(Ra1,Safran_Data.Ra_Safran,'Rows','complete');
RMSE_Ra_Safran = sqrt(mean((Ra1-Safran_Data.Ra_Safran).^2,'omitnan'));

figure(); % Radiation shortwave mesuré et Rs ERA5
Rs_measured_plot = plot(Safran_Data.Time,Rs1,'DisplayName','Measured Rs');
grid on;
title('Comparaison Rs Era5');
xlabel(' temps ');
ylabel(' MJ/m²'); 
hold on;
Rs_Era5_plot = plot(Safran_Data.Time,Rs_ERA5,'DisplayName','Rs Era5');
legend([Rs_measured_plot, Rs_Era5_plot]);

figure(); % Données normalisés Rs Era5
norm_Rs_measure_plot = scatter(norm_data_Rs_ERA5,norm_data_Rs_measure,'DisplayName','Normalized comparaison Rs Measure');
grid on;
title('Norm Rs Era5');
hold on ; 
norm_Rs_Era5_plot = scatter(norm_data_Rs_measure,norm_data_Rs_ERA5,'DisplayName','Normalized comparaison Rs Era5');
hold on;
x = [0:0.25:1];
y = x;
line_plot = plot(x, y);
legend([norm_Rs_measure_plot,norm_Rs_Era5_plot]);

figure(); % Radiation shortwave mesuré et Ra ERA5
Ra_measured_plot = plot(Safran_Data.Time,Ra1,'DisplayName','Measured Ra');
grid on;
title('Comparaison Ra Era5');
xlabel(' temps ');
ylabel(' MJ/m²'); 
hold on;
Ra_Era5_plot = plot(Safran_Data.Time,Ra_ERA5,'DisplayName','Ra Era5');
legend([Ra_measured_plot, Ra_Era5_plot]);


figure(); % Données normalisés Ra Era5
norm_Ra_measure_plot = scatter(norm_data_Ra_ERA5,norm_data_Ra_measure,'DisplayName','Normalized comparaison Ra Measure');
grid on;
title('Norm Ra Era5');
hold on ; 
norm_Ra_Era5_plot = scatter(norm_data_Ra_measure,norm_data_Ra_ERA5,'DisplayName','Normalized comparaison Ra Era5');
hold on;
x = [0:0.25:1];
y = x;
line_plot = plot(x, y);
legend([norm_Ra_measure_plot,norm_Ra_Era5_plot]);