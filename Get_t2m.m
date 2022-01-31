function [Tair, Tmin, Tmax, esx, esm] = Get_t2m(t2m_global)

Tair = mean(t2m_global);
Tmin = min(t2m_global);
Tmax = max(t2m_global);
esx   = 0.6108*exp(17.27*Tmax./(Tmax+237.3));
esm   = 0.6108*exp(17.27*Tmin./(Tmin+237.3));
    
end

