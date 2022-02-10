function [ressol,ETkC,drainage] = get_simpKcET(ET0,Tp,Fcover,Ke,Ru,Kcmax,ressol)

%% Entrée

% ET0 : Evapotranspiration de référence journalière en mm/jour
% Tp : Total precipitation journalière en mm/jour
% Fcover : Fraction of green vegetation sans unité
% Ke : Soil Evaporation coefficient sans unité
% Ru : réserve utile du sol en mm
% Kcmax : Max value of the canopy transpiration coefficient

%% Sortie

% ressol : Réserve en eau du sol en mm
% ETkC : Evapotranspiration selon modèle simpKcET
% drainage : eau excédentaire après une pluie en mm

Ks = ressol / (0.7*Ru); % Calcul du coefficient Ks (water stress coefficient)
drainage = 0;

if (Ks > 1)
    Ks = 1;
end

% Kt = Fcover*Ks*Kcmax;
Kc = Ke+((Kcmax*Ks-Ke).*Fcover); % Calcul du coefficient Kc avec Kt et Ke réagrégé avec Fcover
 
ETkC = ET0.*Kc; %ET selon le modèle SimpKcET

ressol = ressol + Tp-ETkC; % Bilan hydrique

if ressol > Ru
    drainage = ressol - Ru; % Calcul du drainage en fonction de Ru
    ressol = Ru;
end

if ressol < 0
    ressol = 0;
end

end

