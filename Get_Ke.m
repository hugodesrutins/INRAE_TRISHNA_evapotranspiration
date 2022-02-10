function [Ke,Kini] = Get_Ke(FCOVER,Ssm,ET0,a,b,FROCKS)

%% Calcul de Kini et Ke (Soil evaporation coefficient)

Kini = (1+((ET0/a).^b)).^-1;
Kini = real(Kini);
Ke = (1-FCOVER)*(1-FROCKS)*Kini;

    
end

