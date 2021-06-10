function a = simpleAbsorption (f_kHz, t)
%
% function a = simpleAbsorption (f_kHz, t)
%
%     To get the absorption coefficient at a given frequency and temperature.
% Coefficient is given by:
%                         a = f^2 * 0.17 / (18 + t)
%
% Inputs:
%     -f_kHz: frequency in kHz (could be a vector).
%     -t: temperature in °C.
%
% Ouput:
%     -a: the linear attenuation coefficient(s).
%
% FIXME is a per meter or per kilometer ?

t     = t(:)';
f_kHz = f_kHz(:);


a = repmat (f_kHz.*f_kHz, 1, length(t)) ...
            * 0.17 ./ (18 + repmat(t, length (f_kHz), 1));

%!demo
%! f = (0.001:0.05:100)';
%! a = simpleAbsorption (f, 0:10:30);
%! figure (1);
%! plot (f, 20 * log10 (a))
%! grid on
%! xlabel ('Frequences en kHz')
%! ylabel ('Attenuation en dB')
