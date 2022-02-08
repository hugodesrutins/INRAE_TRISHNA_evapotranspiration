function [t] = get_Time_Safran(data)

date_day = data(:,1);
date_month = data(:,2); 
date_year = data(:,3);
t = datetime(date_year,date_month,date_day);

end

