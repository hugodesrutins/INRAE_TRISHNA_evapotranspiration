function [u2] = get_windSpeed(u10_global,v10_global)

z = 10;
u10_mean = mean(u10_global);
v10_mean = mean(v10_global);

uz = sqrt((u10_mean).^2+(v10_mean).^2);
u2 = uz*4.87/log( 67.8*z-5.42 );

end

