%% Modèle SimpKcET : Chargement et mise en formes des fichiers netcdf FCOVER ProbaV 300m
clc
clear all;

%% Import des fichiers

path = '\\147.100.1.28\Remote_Sensing\COPERNICUS_albert_final\fCOVER_vito\300m_probaV\';
path_subfolder = dir(path);
path_subfolder = struct2table(path_subfolder);
subfolder_name = path_subfolder.name;
subfolder_name([1:2], :) = [];
fileslist = load('files_nc.mat');
fileslist = struct2array(fileslist);


for i = 1:146
    complete_path = append(path,subfolder_name{i});
    full_Filename = fullfile(complete_path,fileslist{i});
    variables = netcdf_info(full_Filename);
%     time_vec{i} = get_time_data(full_Filename);
    time_str{i} = extractBetween(full_Filename,89,96);
    [index_long_pt, index_lat_pt] = get_coordinates_fromFC(full_Filename,5.6791,43.2408); % On récupère 1 index pour la latitude et la longitude
%     [index_long_pt2, index_lat_pt2] = get_coordinates_from1pt(filename_TP,5.8,43.9); % On récupère 1 index pour la latitude et la longitude
    FCOVER_FV{i} = extract_varFC300m(index_long_pt,index_lat_pt,'FCOVER',full_Filename); % Extrait les données pour 1 pt précis
end

for i = 149:numel(fileslist)
    complete_path = append(path,subfolder_name{i});
    full_Filename = fullfile(complete_path,fileslist{i});
    variables = netcdf_info(full_Filename);
%     time_vec{i} = get_time_data(full_Filename);
    time_str{i} = extractBetween(full_Filename,89,96);
    [index_long_pt, index_lat_pt] = get_coordinates_fromFC(full_Filename,5.75,43.25); % On récupère 1 index pour la latitude et la longitude
%     [index_long_pt2, index_lat_pt2] = get_coordinates_from1pt(filename_TP,5.8,43.9); % On récupère 1 index pour la latitude et la longitude
    FCOVER_FV{i} = extract_varFC300m(index_long_pt,index_lat_pt,'FCOVER',full_Filename); % Extrait les données pour 1 pt précis
end

FCOVER_FV = FCOVER_FV';
FCOVER_FV([end-4:end]) = [];
FCOVER_FV([147:148]) = [];
time_str = time_str';
Time_data = vertcat(time_str{:});
Time_data([end-4:end]) = [];
for j = 1 : numel(Time_data)
    out = datestr(datenum(num2str(Time_data{j}, '%d'), 'yyyyMMdd'), 'yyyy:MM:dd');
    out = convertCharsToStrings(out);
    out = unique(out,'rows','stable');
    date(j) = datetime(out,'InputFormat','yyyy:MM:dd');
end

date = date';
% FCOVER_FV([1:148]) = [];

varname = {'F_COVER_300m'};
varname2 = {'F_COVER'};
F_COVER_TT  = array2timetable(FCOVER_FV,'RowTimes',date,'VariableNames',varname2); 
F_COVER_TT = retime(F_COVER_TT,'daily','previous');
save('F_COVER_300m_probaV','F_COVER_TT');

% F_COVER_firstpart = load('F_COVER_firstpart.mat');
% F_COVER_firstpart = struct2array(F_COVER_firstpart);
% 
% F_COVER_secondpart = load('F_COVER_secondpart.mat');
% F_COVER_secondpart = struct2array(F_COVER_secondpart);
% 
% F_COVER_300m_ProbaV = [F_COVER_firstpart;F_COVER_secondpart];

%  TP_global = extract_var(index_long_pt2,index_lat_pt2,'tp',filename_TP,Time_data)*1e3; 
%  squeeze(TP_global);
%  TP_global = mean(reshape(TP_global,[24,numel(TP_global(:,1)/24)]));