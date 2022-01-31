function [Dair, Dmin, Dmax,ea] = Get_d2m(d2m_global)

Dair = mean(d2m_global);
Dmin = min(d2m_global);
Dmax = max(d2m_global);
ea=0.611*exp(5418*(1/273.16- 1./Dair));

end


