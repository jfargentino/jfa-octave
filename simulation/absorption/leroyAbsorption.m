function a = leroyAbsorption (f_kHz)
%
% function a = leroyAbsorption (f_kHz)
%
% Sound absorption coefficient from Leroy formula,
% used in the Mediterranean sea.
% TODO validity condition.
% TODO is the return in dB/km?


f2 = f_kHz .* f_kHz;
a  = 0.001 + 0.007*f2 + 0.2635*f2/(2.89 + f2);
