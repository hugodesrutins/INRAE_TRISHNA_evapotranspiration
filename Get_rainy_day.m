function [n] = Get_rainy_day(date_debut, date_fin,date_str,total_precipitation)

Index_debut = find(date_str==date_debut);
Index_fin = find(date_str==date_fin);

temp = 0;
for i = Index_debut : Index_fin
    if total_precipitation(i) > 1.00
        temp = temp+1;
    end 
end
n = temp;
end

