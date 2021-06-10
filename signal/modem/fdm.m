function x = fdm (y, fc, fsr, fdev)
%
% function x = fdm (y, fc, fsr, fdev)
%
% Frequency demodualtion, demodulate a signal 'y' sampled at 'fsr', assuming
% that the carrier is 'fc'. 'fdev' (0.001 per default) is the frequency
% deviation relative to the carrier frequency: delta F = fdev * fc.
% Thus the modulation indice is given by h = (fc*fdev) / Fmax where Fmax is 
% the maximum frequency of the modulating signal.
%

if (nargin < 4)
    fdev = 0.001;
end

% TODO how not to freq-left-shift y?
% something like diff(unwrap (angle (y))) - fc (use ifreq)
% TODO x = pdm ([zeros(1, col); diff(y) ...

[row, col] = size (y);
t = repmat ((0:row-1)' / fsr, 1, col);
y2 = hilbert (y) .* exp (-2*i*pi*fc*t);
x = (fsr / (2 * pi * fc) / fdev ) * [zeros(1, col); diff(unwrap (angle (y2)))];
