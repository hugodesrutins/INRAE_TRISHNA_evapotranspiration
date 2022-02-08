function [data_years] = get_Safrandata_year(working_file,first_year,last_year)

data = readmatrix(working_file);
data_year_index = find((data(:,3)<=last_year) & (data(:,3)>=first_year));
data_years = data(data_year_index,:);

end

