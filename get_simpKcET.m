function [ressol,ETkC,drainage] = get_simpKcET(ET0,Tp,Fcover,Ke,Ru,Kcmax,ressol)

%% Entr�e

% ET0 : Evapotranspiration de r�f�rence journali�re en mm/jour
% Tp : Total precipitation journali�re en mm/jour
% Fcover : Fraction of green vegetation sans unit�
% Ke : Soil Evaporation coefficient sans unit�
% Ru : r�serve utile du sol en mm
% Kcmax : Max value of the canopy transpiration coefficient

%% Sortie

% ressol : R�serve en eau du sol en mm
% ETkC : Evapotranspiration selon mod�le simpKcET
% drainage : eau exc�dentaire apr�s une pluie en mm

Ks = ressol / (0.7*Ru); % Calcul du coefficient Ks (water stress coefficient)
drainage = 0;

if (Ks > 1)
    Ks = 1;
end

% Kt = Fcover*Ks*Kcmax;
Kc = Ke+((Kcmax*Ks-Ke).*Fcover); % Calcul du coefficient Kc avec Kt et Ke r�agr�g� avec Fcover
 
ETkC = ET0.*Kc; %ET selon le mod�le SimpKcET

ressol = ressol + Tp-ETkC; % Bilan hydrique

if ressol > Ru
    drainage = ressol - Ru; % Calcul du drainage en fonction de Ru
    ressol = Ru;
end

if ressol < 0
    ressol = 0;
end

end

