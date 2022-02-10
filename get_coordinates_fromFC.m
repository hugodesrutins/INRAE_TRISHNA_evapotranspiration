function [long_index,lat_index] = get_coordinates_fromFC(filename,long_v, lat_v)

latitude = ncread(filename, 'lat'); % latitude
longitude = ncread(filename, 'lon'); % longitude


long_index = find(abs(longitude - long_v) < 0.05);
lat_index = find(abs(latitude - lat_v) < 0.05);

end

