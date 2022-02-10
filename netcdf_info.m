function [var_name] = netcdf_info(filename)

ncid = netcdf.open(filename);
ncdisp(filename);
[~,nvars,~,~] = netcdf.inq(ncid);

 var_name = {};
for i = 1 : nvars 
    [var_name_t]= netcdf.inqVar(ncid,i-1);
     var_name{i} = var_name_t;
    i = i +1;
end

end

