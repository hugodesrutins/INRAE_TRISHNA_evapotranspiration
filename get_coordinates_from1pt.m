function [long_index,lat_index] = get_coordinates_from1pt(filename,long_v, lat_v)

latitude = ncread(filename, 'latitude'); % latitude
longitude = ncread(filename, 'longitude'); % longitude


long_index = find(abs(longitude - long_v) < 0.001);
lat_index = find(abs(latitude - lat_v) < 0.001);

end

