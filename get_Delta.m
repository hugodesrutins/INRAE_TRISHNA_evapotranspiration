function [Delta,es] = get_Delta(esx,esm,Tair)

es = (esm+esx)./2;
Delta = 4098*es./( Tair+237.3 ).^2;

end

