function [ET0_ERA5_FAO_MF_TT, ET0_ERA5_FAO,ET0_ERA5_MF,tp_global] = ET0_Penman_Monteith_load_calc(path,nbr_mesure_daily,longitude,latitude)

%% Entrée

% path : Spécifier le chemin d'accès complet du dossier dans lequel sont
% rangées vos fichiers netcdf. Les fichiers doivent être rangées par ordre
% temporel croissant (de l'année la + vieille vers l'année la plus récente)

% nbr_mesure_daily : Cette variable représente le nombre de mesures
% éffectuées par jour dans vos fichiers netcdf, typiquement si le jeu de
% donnée contient une donnée toutes les heure nbr_mesure_daily = 24

%Longitude : Longitude du point d'étude / Latitude : Latitude du point
%d'étude

%% Sortie

%ET0_ERA5_FAO_MF_TT : Evapotranspiration de référence selon modèle FA0 et MF
%Penman-Monteith sous format TimeTable avec export en .csv et affichage
%sous forme de série temporelle.

%ET0_ERA5_FAO : Evapotranspiration de référence selon modèle FAO Penman
%monteith, données brutes

%ET0_ERA5_MF : Evapotranspiration de référence selon modèle MF Penman
%monteith, données brutes

%tp_global : Total precipitation en mm, export pour modèle simpKcET.

%% Lecture des fichiers

addpath = path; 
files = dir(addpath);
files = struct2table(files);
filesname = files.name;
filesname([1:2], :) = [];

%% Boucle de récupération des données par variable

for i = 1:numel(filesname)
    
    full_Filename = fullfile(addpath,filesname{i});
    full_Filename = char(full_Filename);
    variables = netcdf_info(full_Filename);
    time_vec{i} = get_time_data(full_Filename);
    [indexes_long, indexes_lat] = get_coordinates_from1pt(full_Filename,longitude,latitude);
    t2m_global{i} = extract_var(indexes_long,indexes_lat,'t2m',full_Filename,time_vec{i})-273.15 ; %température en °C
    t2m_global{i} = squeeze(t2m_global{i});
    d2m_global{i} = extract_var(indexes_long,indexes_lat,'d2m',full_Filename,time_vec{i}); %température pt de rosée en °C
    d2m_global{i} = squeeze(d2m_global{i});
    u10_global{i} = extract_var(indexes_long,indexes_lat,'u10',full_Filename,time_vec{i});
    u10_global{i} = squeeze(u10_global{i});
    v10_global{i} = extract_var(indexes_long,indexes_lat,'v10',full_Filename,time_vec{i}); 
    v10_global{i} = squeeze(v10_global{i});
    ssr_global{i} = extract_var(indexes_long,indexes_lat,'ssr',full_Filename,time_vec{i})/1e6; % incoming solar radiation  J/m2 Rs
    ssr_global{i} = squeeze(ssr_global{i});
    str_global{i} = extract_var(indexes_long,indexes_lat,'str',full_Filename,time_vec{i})/1e6; % atmosphéric radiaiton J/m2 Ra
    str_global{i} = squeeze(str_global{i});
    sp_global{i} = (extract_var(indexes_long,indexes_lat,'sp',full_Filename,time_vec{i}))/1e3; %pression en kPa
    sp_global{i} = squeeze(sp_global{i});
    tp_global{i} = (extract_var(indexes_long,indexes_lat,'tp',full_Filename,time_vec{i}))*1e3; % Précipitation en mm
    tp_global{i} = squeeze(tp_global{i});
    
end

%% Reshape et concaténation pour exploitation des données

Time_data = vertcat(time_vec{:});
% Time_data = [zeros(1,size(Time_data,2));Time_data];
% Time_data(1 ,:) = [1950;1;1;0;0;0];
daily_shape = numel(Time_data(:,1)) / nbr_mesure_daily;
daily_shape = round(daily_shape);

t2m_global = vertcat(t2m_global{:});
% t2m_global = [zeros(1,size(t2m_global,2));t2m_global];
t2m_global = reshape(t2m_global,[nbr_mesure_daily,daily_shape]);
d2m_global =  vertcat(d2m_global{:});
% d2m_global = [zeros(1,size(d2m_global,2));d2m_global];
d2m_global = reshape(d2m_global,[nbr_mesure_daily,daily_shape]);
u10_global = vertcat(u10_global{:});
% u10_global = [zeros(1,size(u10_global,2));u10_global];
u10_global = reshape(u10_global,[nbr_mesure_daily,daily_shape]);
v10_global = vertcat(v10_global{:});
% v10_global = [zeros(1,size(v10_global,2));v10_global];
v10_global = reshape(v10_global,[nbr_mesure_daily,daily_shape]);
ssr_global = vertcat(ssr_global{:});
% ssr_global = [zeros(1,size(ssr_global,2));ssr_global];
ssr_global = reshape(ssr_global,[nbr_mesure_daily,daily_shape]);
str_global =  vertcat(str_global{:});
% str_global = [zeros(1,size(str_global,2));str_global];
str_global = reshape(str_global,[nbr_mesure_daily,daily_shape]);
sp_global = vertcat(sp_global{:});
% sp_global = [zeros(1,size(sp_global,2));sp_global];
sp_global = reshape(sp_global,[nbr_mesure_daily,daily_shape]);
tp_global = vertcat(tp_global{:});
% tp_global = [zeros(1,size(tp_global,2));tp_global];
tp_global = reshape(tp_global,[nbr_mesure_daily,daily_shape]);

%% Calcul et conversion des différents paramètres pour calcul ET0

date_str = datestr(Time_data,'yyyy-mmm-dd');
date_str = unique(date_str,'rows','stable');
date = (datetime(date_str));

[Tair, Tmin, Tmax, esx, esm] = Get_t2m(t2m_global); % Appel de la fct Get_t2m pour obtenir les paramètres de température
[Dair, Dmin, Dmax,ea] = Get_d2m(d2m_global); % Appel de la fct Get_d2m pour obtenir les paramètres
[Delta,es] = get_Delta(esx,esm,t2m_global); % calcul de Delta
Delta = mean(Delta);
% ssrd_global([2:8],:) = [];
Rns = mean(ssr_global); %solar radiation shortwave
Rnl = mean(str_global); % thermal radiation longwave
Rn = get_Rn(Rnl,Rns,Tmax,Tmin);
u2 = get_windSpeed(u10_global,v10_global);
raMF = 1./(0.007+0.0056*u2);
gamma = get_Gamma(sp_global); % Calcul de Gamma

Rn_Safran = load('RN_Safran_TT.mat');
Rn_Safran = struct2array(Rn_Safran);
Rn_idx1 = timerange("01-Jan-1959","01-Jan-1983");
Rn_idx2 = timerange("01-Jan-1998","01-Jan-2021");
Rn_Safran_idx1 = Rn_Safran(Rn_idx1,:);
Rn_Safran_idx2 = Rn_Safran(Rn_idx2,:);
Rn_S = [Rn_Safran_idx1 ; Rn_Safran_idx2];
Rn_S = Rn_S.Rn;
Rn_S = Rn_S';

%% Calcul de ET0

ET0_ERA5_FAO = ET_Penman_Monteith_FAO(Delta,Tair,Rn_S,0,gamma,u2,es,ea); % ET0 FAO 56
ET0_ERA5_FAO = squeeze(ET0_ERA5_FAO);
ET0_ERA5_FAO = ET0_ERA5_FAO';

ET0_ERA5_MF = ET_Penman_Monteith_MF(Delta,Tair,Rn_S,0,gamma,raMF,es,ea); % ET0 Météo france
ET0_ERA5_MF = squeeze(ET0_ERA5_MF);
ET0_ERA5_MF = ET0_ERA5_MF';


varname1 = {'ET0_ERA5_FAO_daily'};
varname2 = {'ET0_ERA5_MF_daily'};
ET0_ERA5_FAO_TT  = array2timetable(ET0_ERA5_FAO,'RowTimes',date,'VariableNames',varname1); %% Timetable complète
ET0_ERA5_MF_TT =  array2timetable(ET0_ERA5_MF,'RowTimes',date,'VariableNames',varname2);

ET0_ERA5_FAO_MF_TT = [ET0_ERA5_FAO_TT  ET0_ERA5_MF_TT];

ET0_ERA5_FAO_Monthly = retime(ET0_ERA5_FAO_TT,'monthly','sum');
ET0_ERA5_FAO_Yearly = retime(ET0_ERA5_FAO_TT,'yearly','sum');

ET0_ERA5_MF_Monthly = retime(ET0_ERA5_MF_TT,'monthly','sum');
ET0_ERA5_MF_Yearly = retime(ET0_ERA5_MF_TT,'yearly','sum');

writetimetable(ET0_ERA5_FAO_MF_TT,'ET0_ERA5_FAO_MF.csv','Delimiter',';');
type 'ET0_ERA5.csv';

figure(1);
plot(ET0_ERA5_FAO_MF_TT.Time,ET0_ERA5_FAO_MF_TT.ET0_ERA5_FAO_daily);
legend('ET0-ERA5-FAO')
grid on;
title('ET0-FAO avec données ERA5 Land');
xlabel(' temps ');
ylabel(' ET0(mm/day) '); 


figure(2);
plot(ET0_ERA5_FAO_MF_TT.Time,ET0_ERA5_FAO_MF_TT.ET0_ERA5_FAO_daily);
legend('ET0-ERA5-MF')
grid on;
title('ET0-MF avec données ERA5 Land');
xlabel(' temps ');
ylabel(' ET0(mm/day) '); 

figure(3);
plot(ET0_ERA5_FAO_Monthly.Time,ET0_ERA5_FAO_Monthly.ET0_ERA5_FAO_daily);
legend('ET0-ERA5-Monthly')
grid on;
title('ET0-FAO avec données ERA5 Land par mois');
xlabel(' temps ');
ylabel(' ET0(mm/mois) '); 

figure(4);
plot(ET0_ERA5_MF_Monthly.Time,ET0_ERA5_MF_Monthly.ET0_ERA5_MF_daily);
legend('ET0-ERA5-Monthly')
grid on;
title('ET0-MF avec données ERA5 Land par mois');
xlabel(' temps ');
ylabel(' ET0(mm/mois) '); 

corr_coef = corrcoef(ET0_ERA5_FAO_MF_TT.ET0_ERA5_FAO_daily, ET0_ERA5_FAO_MF_TT.ET0_ERA5_MF_daily)

% savepath = 'C:\Users\hdesrutins\Documents\INRAE\test\Matlab\SimpKcET';
% save(fullfile(savepath,'ea_test'),'ea');
% save(fullfile(savepath,'gamma_test'),'gamma');

end

