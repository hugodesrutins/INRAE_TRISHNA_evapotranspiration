%% Evapotranspiration modelling with Safran Data

% Authors :   Desrutins Hugo and Albert Olioso
% Company : INRAE Avignon
% Version :     January 2021 
% Last revision: February 2022

clc;
clearvars
close all;

%% Import Data

% Les données Safran sont divisés en maille, on utilise la fonction
% Get_maille pour isoler la / les mailles dont on a besoin

load('list_file_char.mat');
file_listemaille = readmatrix('2013_liste_mailles_safran_France_métropolitaine.csv');
working_maille = Get_maille(file_listemaille, 4.8788,43.9164); % Working coordinates
working_maille = num2str(working_maille);

addpath = '\\147.100.1.28\Donnees_climatiques\reanalyses\SAFRAN\donnees_journalieres_1958_2021\Dossier_2021-Albert\';

for i = 1 : numel(working_maille(:,1))
    
    working_maille_str(i)= convertCharsToStrings(working_maille(i,:));
    working_tmp(i) = append('quotidiennes_1958_2021_maille_',working_maille_str(i),'.csv');
    working_file(i) = append(addpath,working_tmp(i));

end
  

%% Read and extract data

for j = 1 : numel(working_file)
    
    info{j} = readtable(working_file(j));
    data{j} = readmatrix(working_file(j));
    
end

for k = 1 : numel(data)

    ET0_SAFRAN{k} = data{1,k}(:,17);
    ETR_SAFRAN{k} = data{1,k}(:,16);
    Ra{k} = data{1,k}(:,14);
    Rs{k} = data{1,k}(:,15);
    Tp{k} = data{1,k}(:,8);
    Tair{k} = data{1,k}(:,10);
    Tmin{k} = data{1,k}(:,11);
    Tmax{k} = data{1,k}(:,12);
    u2{k} = data{1,k}(:,13);
    
    
end
t = get_Time_Safran(data{1,1});
Ra_m =[Ra{1,1}]/1e2 ;
% Ra_m = mean(Ra_m,2);
Rs_m =[Rs{1,1}]/1e2;
% Rs_m = mean(Rs_m,2);
ET0_SAFRAN_m = [ET0_SAFRAN{1,1}];
% ET0_SAFRAN_m =mean(ET0_SAFRAN_m,2);
ETr_SAFRAN_m = [ETR_SAFRAN{1,1}];
% ETr_SAFRAN_m = mean(ETr_SAFRAN_m,2);
Tp_m = [Tp{1,1}];
% Tp_m = mean(Tp_m,2);
Tair_m =  [Tair{1,1} ];
% Tair_m = mean(Tair_m,2);
Tmin_m = [Tmin{1,1}];
% Tmin_m = mean(Tmin_m,2);
Tmax_m = [Tmax{1,1}];
% Tmax_m = mean(Tmax_m,2);
u2_m = [u2{1,1}];
% u2_m = mean(u2_m,2);

Data_safran = [ET0_SAFRAN_m ETr_SAFRAN_m Tp_m Tair_m Tmax_m Tmin_m u2_m Rs_m Ra_m];
varnames = {'ET0_SAFRAN','ETR_SAFRAN','Tp_Safran','Tair_Safran','Tmax_Safran','Tmin_Safran','wind_Safran','Rs_Safran','Ra_Safran'};

Data_Safran_TT = array2timetable(Data_safran,'RowTimes',t,'VariableNames',varnames);

Data_ERA5 = load('ET0_ERA5_TT.mat');
Data_ERA5 = struct2array(Data_ERA5);
Data_SimpKcET = load('ETkC_ERA5_FAO_daily.mat');
Data_SimpKcET = struct2array(Data_SimpKcET);
Data_SimpKcET_tmr = timerange("10-Nov-1998","31-Dec-2020");
Data_ERA5_tmr = timerange("01-Jan-1959","31-Dec-2020");
Data_Safran_TT = Data_Safran_TT(Data_ERA5_tmr,:);
Data_Safran_TT_simpKcET = Data_Safran_TT(Data_SimpKcET_tmr,:);
Data_ERA5 = Data_ERA5(Data_ERA5_tmr,:);


Rn_Safran = get_Rn(Data_Safran_TT.Ra_Safran,Data_Safran_TT.Rs_Safran,Data_Safran_TT.Tmax_Safran,Data_Safran_TT.Tmin_Safran,0.23);
Rn_TT = array2timetable(Rn_Safran,'RowTimes',Data_Safran_TT.Time,'VariableNames',{'Rn'});

savepath = 'C:\Users\hdesrutins\Documents\INRAE\test\Matlab\Test_Real_data';
savepath2 = 'C:\Users\hdesrutins\Documents\INRAE\test\Matlab\SimpKcET';

esx   = 0.6108*exp(17.27*Data_Safran_TT.Tmax_Safran./(Data_Safran_TT.Tmax_Safran+237.3));
esm   = 0.6108*exp(17.27*Data_Safran_TT.Tmin_Safran./(Data_Safran_TT.Tmin_Safran+237.3));
[Delta,es] = get_Delta(esx,esm,Data_Safran_TT.Tair_Safran);
raMF = 1./(0.007+0.0056*Data_Safran_TT.wind_Safran);

ET0_SAFRAN_FAO = ET_Penman_Monteith(Delta,Data_Safran_TT.Tair_Safran,Rn_Safran,0,Data_ERA5.gamma,Data_Safran_TT.wind_Safran,es,Data_ERA5.ea);
ETO_SAFRAN_MF = ET_Penman_Monteith_MF(Delta,Data_Safran_TT.Tair_Safran,Rn_Safran,0,Data_ERA5.gamma,raMF,es,Data_ERA5.ea);

varname = {'ET0_SAFRAN_FAO'};
varname2 = {'ET0_SAFRAN_MF'};
ET0_SAFRAN_FAO_TT = array2timetable(ET0_SAFRAN_FAO,'RowTimes',Data_ERA5.Time,'VariableNames',varname);
ET0_SAFRAN_MF_TT = array2timetable(ETO_SAFRAN_MF,'RowTimes',Data_ERA5.Time,'VariableNames',varname2);
ET0_SAFRAN_FAO_MF = [ET0_SAFRAN_FAO_TT ET0_SAFRAN_MF_TT  Data_Safran_TT Rn_TT];


save(fullfile(savepath,'ET_variables_SAFRAN_Fontblanche'),'ET0_SAFRAN_FAO_MF');
save(fullfile(savepath2,'ET_variables_SAFRAN_Fontblanche'),'ET0_SAFRAN_FAO_MF');
