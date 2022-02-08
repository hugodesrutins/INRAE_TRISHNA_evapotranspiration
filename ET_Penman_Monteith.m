function [ET0] = ET_Penman_Monteith(Delta, Tair, Rn, G, gamma, u2, es, ea)
    
 
ET0 = ( 0.408*Delta.*( Rn-G )+gamma*900./( Tair+273 ).*u2.*( es-ea ) )./( Delta+gamma.*( 1+0.34*u2 ) );

%% unités
%ET0 (mm.jour^-1)
%Rn (MJ m^-2 jour^-1)
%G (MJ m^-2 jour^-1)
%Tair (°C)
%u2 (M.s^-1)
% es (kPa)
% ea (kPa)
% Delta (kPa °C^-1)
% sigma (kPa °C^-1)


end