function AdB = geometricalAbsorption (d_km)
%
% function AdB = geometricalAbsorption (d_km)
%
% To calculate the attenuation in dB due to geometrical
% dispertion for a distance of 'd_km' kilometers.
%

AdB = 60 + 20 * log10 (d_km);
