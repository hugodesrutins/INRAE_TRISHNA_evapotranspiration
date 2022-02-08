function [working_Maille] = Get_maille(file_listemaille,longitude_v,latitude_v)

longitude = file_listemaille(:,3);
latitude = file_listemaille(:,4);
maille_list = file_listemaille(:,1);

coordonnee = [longitude latitude];

[row,col] = find((abs(coordonnee(:,1) - longitude_v ) < 0.05) & (abs(coordonnee(:,2) - latitude_v ) < 0.05));

working_Maille = maille_list(row);

end

