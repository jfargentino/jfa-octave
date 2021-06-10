function [s, S] = colorizedNoise (F, P, L, Fs, method)
%
% function [s, S] = colorizedNoise (F, P, L [, Fs, method])
%
% To generate a noise colorized by the given frequencies / power couple.
% INPUTS
%  'F' : frequencies where we know the noise power density,
%  'P' : power density per sqrt (Hz) of each provided frequencies,
%  'L' : length of the noise to generate,
%  'Fs': sample frequency of the signal to generate, 2 * (F(end) + 1 Hz) per
%        default;
%  'method': string for the interpolation method to use (see interp1),
%            'linear' per default.
% OUTPUTS
%  's' : temporal generated signal,
%  'S' : spectral generated signal, warning, the length of the spectrum is the
%        next power of two of the provided length.
%
% Files needed:
%     -spectralize.m
%

if (nargin >= 5)
   if (ischar (Fs))
      tmp = method;
      method = Fs;
      Fs = tmp;
   end
end
if (nargin < 5)
   if (ischar (Fs))
      method = Fs;
      Fs = 2 * (max (F) + 1); % TODO marge for Fs of 1Hz!!!
   else
      method = 'linear';
   end
end
if (nargin < 4)
   method = 'linear';
   Fs = 2 * (max (F) + 1); % TODO marge for Fs of 1Hz!!!
end

% Shape in row and sort by increasing frequencies
F = F(:);
P = P(:);
% add the maximum frequency
%F = [F; Fs / 2]
%P = [P; 0]
[F, index] = sort (F);
P = P(index);
% Verify that frequencies are strictly monotonic
nf = find (diff (F) == 0);
if (length (nf) ~= 0)
   warning ('Given frequencies arent strictly monotonic, removing [%f, %f]',...
            F(nf+1), P(nf+1));
   nf = find (diff (F) ~= 0);
   F = [F(nf); F(max(nf + 1))];
   P = [P(nf); P(max(nf + 1))];
end

% take the next power of two:
n = pow2 (nextpow2 (L));
% frequencies support
Fi = Fs * (0 : n/2 - 1) / n;
% generate interpolated power density
Pi = interp1 (F, P, Fi, method, 'extrap');
% change it into a noise spectrum, Fi(2) is the bandpass
S = spectralize (sqrt (Pi * Fi (2))) .* fft (randn (n, 1));
% get signal from its spectrum
s = real (sqrt (n) * ifft (S));
% keep only nb of point we want 
s = s (1:L);

%!demo
%! n = 2^20;
%! Fs = 48000;
%! %method = 'nearest';
%! method = 'linear';
%! %method = 'pchip';
%! %method = 'cubic';
%! %method = 'spline';
%!
%! F = [0.1, 0.5, 1,    5,   10,  50, 100, 500, 1000, 5000, 10000];
%! P = [250, 500, 1000, 100, 10, 500,  50,   5,  250,  2.5, 0.001];
%! s = colorizedNoise (F, P, n, method, Fs);
%!
%! % PINK
%! %F = (1 : 1 : (Fs/2-1))';
%! %P = ones(length(F), 1) ./ F;
%! %s = colorizedNoise (F, P, n, method, Fs);
%! 
%! % A-weighting
%! %F = [ 20, 50, 200, 500, 1000, 3000, 4000, 7000, 10000, 20000, Fs/2-1]
%! %P = [ 1e-5, 1e-3, 0.1, 0.5,1,  1.2,  1.2,    1,   0.5, 1e-5, 1e-9 ]
%! %P = [ 1e5, 1e3, 10, 2,1,  0.8,  0.8,    1,   2, 1e5, 0 ]
%! %s = colorizedNoise (F, P, n, method, Fs);
%! 
%! % ITU-R 468 low part
%! f = sqrt(1000)
%! F = [  10,   f, 100,10*f, 1000, 3000, 6000, Fs/2-1 ]
%! P = [ 1e4, 1e3, 1e2,  10,    1,  0.1, 0.05,   0.05 ]
%! s = colorizedNoise (F, P, n, method, Fs);
%! 
%! % ITU-R 468 high part
%! %f = sqrt(300)
%! %F = [ 1, 6000, 9000, 10000,  20000, Fs/2-1 ]
%! %P = [ 0,    1,    2,    10,   1000,      0 ]
%! %s = colorizedNoise (F, P, n, method, Fs);
%! 
%! % ISO 226
%!
%! n_psd = n / 8;
%! S = psdm (s, n_psd);
%! S = S (1:n_psd / 2);
%! f = Fs * (0:n_psd/2 - 1) / n_psd;
%! figure;
%! semilogx (f(2:end), 10*log10(S(2:end)) - 10*log10(f(2)), '1');
%! hold on, semilogx (F, 10*log10(P), '0'); grid on,
%! title ([method, ' interpolation']);
%! legend ('psd of the generated noise', 'reference psd'), 
%! xlabel ('Frequency'), ylabel ('dB / sqrt (Hz)'), hold off
%! xticks (F);
%! yticks (10*log10(P));

