function [gamma] = get_Gamma(sp_global)

sp_mean = mean(sp_global);
gamma = 0.665*10^-3*sp_mean;

end

