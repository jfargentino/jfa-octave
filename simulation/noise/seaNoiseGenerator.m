function [n, s] = seaNoiseGenerator (Fs, L, Skt)
%
% function [n, s] = seaNoiseGenerator (Fs, L, Skt)
%
% To generate ambiant sea noise corresponding to the generally accepted model.
%  'Fs' sample in Hz
%  'L' length to generate
%  'Skt' wind speed in knots (0 per default);
%
% Files needed:
%     -seaNoisePerSqrtHz.m
%     -seaThermalNoise.m
%     -spectralize.m
%

if (nargin < 3)
   Skt = 0;
end

Fmax = Fs / 2 - 1;

if (Fmax < 39319)
   nf     = ceil (log10 (Fmax));
   f      = 10 .^ (0:0.5:nf);
else
   nf0 = 0:0.5:4;
   nf1 = 5 : 0.5 : ceil (log10 (Fmax));
   f   = [10 .^ (nf0), 39319, 10 .^ (nf1)];
end

dBHz   = max (seaNoisePerSqrtHz (f, Skt), seaThermalNoise (f));
pHz    = 10 .^ (dBHz / 10);
[n, s] = colorizedNoise (f, pHz, L, Fs, 'pchip');

%!demo
%! samplerate = 192000;
%! n = log2 (samplerate);
%! if (samplerate / 2 > 39319)
%!   f = sort ([2.^(0:(n-1)), 39319, samplerate / 2]);
%! else
%!   f = sort ([2.^(0:(n-1)), samplerate / 2]);
%! end
%! L = 131072 * 8;
%! s = seaNoiseGenerator (samplerate, L);
%! n = 131072;
%! S = psdm (s, n, n / 4);
%! S = n * S (1:n/2) / samplerate;
%! fs = samplerate * (0:n/2 - 1) / n;
%! dBHz = max (seaNoisePerSqrtHz (f), seaThermalNoise (f));
%! semilogx (fs (2:end), 10 * log10 (S(2:end)));
%! hold on,
%! semilogx (f, dBHz, '2');
%! grid on;
%! xlabel ('Frequency');
%! ylabel ('dB (ref 1uPa) / sqrt Hz');
%! hold off

