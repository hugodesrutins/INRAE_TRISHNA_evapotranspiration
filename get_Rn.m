function [Rn_SAFRAN] = get_Rn(Ra,Rs,Tmax,Tmin,albedo)


RnsFAO = (1-albedo).*Rs;

Rnl2   =  (4.903e-9)*( ( Tmax+273.16 ).^4+( Tmin+273.16 ).^4 )/2.*0.98 - Ra;
Rn_SAFRAN  = RnsFAO - Rnl2;

end

