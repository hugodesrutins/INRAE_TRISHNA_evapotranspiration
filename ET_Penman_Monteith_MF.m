function [ET0] = ET_Penman_Monteith_MF(Delta, Tair, Rn, G, gamma, raMF, es, ea)
    
 
ET0 = ( 0.408*Delta.*( Rn-G )+gamma*187200./( Tair+273 )./raMF.*( es-ea ) )./( Delta+gamma.*( 1+60./raMF ) );

%% unités
%ET0 (mm.jour^-1)
%Rn (MJ m^-2 jour^-1)
%G (MJ m^-2 jour^-1)
%Tair (°C)
%u2 (m.s^-1)
% es (kPa)
% ea (kPa)
% Delta (kPa °C^-1)
% gamma (kPa °C^-1)

end

