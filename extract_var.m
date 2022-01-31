function [data_var] = extract_var(index_long, index_lat,varname,filename,time_vec)

vardata= ncread(filename, varname);
n = numel(time_vec(:,1));
data_var = [];
for i = 1 : numel(index_long)
    for k = 1 : numel(index_lat)
        for j = 1 : n
            tempo = vardata(index_long(i), index_lat(k), j);
            data_var(i,k,j) = tempo;     
        end
    end
end

end
