function [Rn_SAFRAN] = get_Rn(Ra,Rs,Tmax,Tmin)

% alpha_FAO56  = 0.23;
% RnsFAO = (1-alpha_FAO56)*Rs %Net shortwave radiation
% Rnl2   =  (4.903e-9)*( ( Tmax+273.16 ).^4+( Tmin+273.16 ).^4 )/2.*0.98 - Ra;
Rn_SAFRAN  = Rs-Ra;

end

