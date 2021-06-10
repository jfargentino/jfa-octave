function dBHz = seaNoisePerSqrtHz (f, Vkt)

if (nargin < 2)
	Vkt = 0;
end

% frequencies in column
[rf, cf] = size (f);
f = f(:);
% wind speed in row
Vkt = Vkt (:)';

dBHz = 44 + sqrt (21 * repmat (Vkt, length (f), 1)) ...
         - 17 * log10 (repmat (f, 1, length (Vkt)) / 1000);
if (rf < cf)
    dBHz = dBHz';
end

%!demo
%! F = [10.^(0:0.5:4)'; (30e3:1e3:300e3)'; 10^6];
%! Vkt = (0 : 10 : 40);
%! dBHz = max (seaNoisePerSqrtHz (F, Vkt), ...
%!             repmat (seaThermalNoise (F), 1, length (Vkt)));
%! semilogx (F, dBHz)
%! grid on
%! xlabel ('Frerquencies in Hz');
%! ylabel ('dB (ref 1uPa) / sqrt (Hz)')
%! legend ('0 kt', '10 kt', '20 kt', '30 kt', '40 kt');
%! title ('Ambiant sea noise regarding the wind speed');
