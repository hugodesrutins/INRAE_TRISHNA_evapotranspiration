%% Modèle simpKcET 

% Code réalisé par : Hugo Desrutins le 20/01/2022
% Ingénieur d'études à l'INRAE
% Basé sur l'article " an evapotranspiration model driven by remote sensing
% data for assessing groundwater ressource in karst Watershed : https://www.documentation.ird.fr/hor/PAR00022863

clc;
clear all;

%% Importe les données FCOVER 

F_COVER_data = load('F_COVER_300m_probaV.mat');
F_COVER_data = struct2array(F_COVER_data);
F_COVER_data2 = load('F_COVER_1km_veg.mat');
F_COVER_data2 = struct2array(F_COVER_data2);
F_COVER_data3 = load('F_COVER_300m_Olci.mat');
F_COVER_data3 = struct2array(F_COVER_data3);

%% Concatenation et Synchronisation des 2 Timetable FCOVER

F_COVER = [F_COVER_data2 ; F_COVER_data ; F_COVER_data3];
F_COVER = retime(F_COVER,'daily','previous');

%% Importe les données ET0

% ET0_ERA5land = load('ET0_ERA5_TT.mat');
% ET0_ERA5land = struct2array(ET0_ERA5land);

Safran_DATA = load('ET_variables_SAFRAN_Fontblanche.mat');
Safran_DATA = struct2array(Safran_DATA);

%% FCOVER 

F_COVER_ERA5land_idx = timerange("10-Nov-1998",Safran_DATA.Time(end));
F_COVER_ERA5land = F_COVER(F_COVER_ERA5land_idx,:);
% ET0_ERA5land = ET0_ERA5land(F_COVER_ERA5land_idx,:);
% ET0_ERA5land_FCOVER = [ET0_ERA5land F_COVER_ERA5land];
Safran_DATA = Safran_DATA(F_COVER_ERA5land_idx,:);
Safran_DATA_Fcover = [Safran_DATA F_COVER_ERA5land];

%% Déclaration des constantes

F_ROCKS_Puechabon = 0.8;
F_ROCKS_Fontblanche = 0.5;
F_ROCKS_Avignon = 0;
b = 2.5;
Ru = 150;

%% Calcul des coefficients.

a = zeros(1,numel(Safran_DATA_Fcover.Time));
for j = 1 : numel(Safran_DATA_Fcover.Time)-20
    
a(j) = Get_rainy_day(Safran_DATA_Fcover.Time(j), Safran_DATA_Fcover.Time(j+20),Safran_DATA_Fcover.Time, Safran_DATA_Fcover.Tp_Safran);

end

a([end-20 : end]) = [a(end-21)];

F_Cover = Safran_DATA_Fcover.F_COVER;
F_Cover = cell2mat(F_Cover);

%% Bilan Hydrique

tic
for i = 1 : numel(Safran_DATA_Fcover.F_COVER)

if (i == 1)
    ressol = Ru;
    [Ke(i),Kini(i)]= Get_Ke(F_Cover(i),1,Safran_DATA_Fcover.ET0_SAFRAN_FAO(i),a(i),b,F_ROCKS_Fontblanche);
    Ke = real(Ke);
    [ressol_t(i),ETkC(i),drainage(i)] = get_simpKcET(Safran_DATA_Fcover.ET0_SAFRAN_FAO(i),Safran_DATA_Fcover.Tp_Safran(i),F_Cover(i),Ke(i),Ru,0.9,ressol(i));
else 
    ressol = ressol_t;
     [Ke(i),Kini(i)]= Get_Ke(F_Cover(i),1,Safran_DATA_Fcover.ET0_SAFRAN_FAO(i),a(i),b,F_ROCKS_Fontblanche);
    Ke = real(Ke);
    [ressol_t(i),ETkC(i),drainage(i)] = get_simpKcET(Safran_DATA_Fcover.ET0_SAFRAN_FAO(i),Safran_DATA_Fcover.Tp_Safran(i),F_Cover(i),Ke(i),Ru,0.9,ressol(i-1));
end

end
toc

ETkC = ETkC';
ressol =ressol';
drainage = drainage';
Ke = Ke';


%% Timetable et Affichage


ETkC_TT = array2timetable(ETkC,'RowTimes',Safran_DATA_Fcover.Time,'VariableNames',{'ETkC'});
save('ETkC_TT_ERA5land.mat','ETkC');
writetimetable(ETkC_TT,'ETkC_TT.csv','Delimiter',';');
ETkC_TT_yearly = retime(ETkC_TT,'yearly','sum');
ETkC_TT_monthly = retime(ETkC_TT,'monthly','sum');

figure(1);
plot(Safran_DATA_Fcover.Time,ETkC);
legend('ETkC-ERA5land')
grid on;
title('ET avec modèle SimpKcET et données ERA5land');
xlabel(' temps ');
ylabel(' ET(mm/day) '); 

figure(2);
plot(ETkC_TT_monthly.Time,ETkC_TT_monthly.ETkC);
legend('ETkC-ERA5land-FAO')
grid on;
title('ET avec modèle SimpKcET et données ERA5land');
xlabel(' temps ');
ylabel(' ET(mm/mois) '); 

savepath = 'C:\Users\hdesrutins\Documents\INRAE\test\Matlab\Test_Real_data';
savepath2 = 'C:\Users\hdesrutins\Documents\INRAE\test\Matlab\SAFRAN';
save(fullfile(savepath,'ETkC_Safran_FAO_daily'),'ETkC_TT');
save(fullfile(savepath,'ETkC_Safran_FAO_monthly'),'ETkC_TT_monthly');
save(fullfile(savepath,'ETkC_Safran_FAO_yearly'),'ETkC_TT_yearly');
save(fullfile(savepath2,'ETkC_Safran_FAO_daily'),'ETkC_TT');
