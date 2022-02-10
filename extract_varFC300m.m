function [data_var] = extract_varFC300m(index_long, index_lat,varname,filename)
%
% 
vardata= ncread(filename, varname,[62000 12000 ],[1000 1000 ]);
index_long = index_long - 62000;
index_lat = index_lat -12000;

data_var = [];
for j = 1 : numel(index_long)
    for k = 1 : numel(index_lat)
            tempo = vardata(index_long(j), index_lat(k));
            data_var(j,k) = tempo;
    end
end
        
% data_var = vardata(index_long-20000,index_lat-4000);

% data_var = data_var(:,~all(isnan(data_var)));
data_var(isnan(data_var))=0;
data_var = mean(data_var,'all'); 

end

