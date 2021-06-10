function y = hartley (x, wc, m)
% AKA the phasing method

if (nargin < 3)
   % TODO many references set it to 2
   m = 1;
end

x = m * oclip (x);
% lower side band
% y = am (x, wc) - am (imag (hilbert (x)), wc, pi/2);
% upper side band
y = am (x, wc) + am (imag (hilbert (x)), wc, pi/2);

%!demo
%! % kc Sampling rate to carrier ratio => Fc = Fsr / kc, the less is the better
%! % to easily remove the carrier, but min is 3 due to Nyquist
%! kc = 3;
%! kl = 20; %kl = 80/3; % carrier to lowest freq ratio => Fl = Fc / kl
%! kh = 8/3; % carrier to highest freq ratio => Fh = Fc / kh
%! m = 1;
%! n = 256; % Filter order
%! N = 32768;
%! [s, fsr] = wavread ('japanese_telecom.wav');
%! s = mean (s, 2);
%!
%! % MODULATION
%! b = fir1 (n, 2*[1/(kl*kc), 1/(kh*kc)]); a = 1;
%! sf = filter (b, a, s);
%! sm = hartley_mod (sf, 1/kc, m);
%! Sf = fold_psd (psdm (sf, N));
%! Sm = fold_psd (psdm (sm, N));
%! f = (0:N/2-1)' * fsr / N;
%! figure;
%! plot (f, 10 * log10 (Sf), f, 10 * log10 (Sm));
%! grid on;
%! legend ('input', 'single side band');
%! str = sprintf ('Sample rate: %.1fkHz, Carrier: %.1fkHz, band: %.1fkHz - %.1fkHz', fsr / 1000, fsr / (kc * 1000), fsr / (kl * kc * 1000), fsr / (kh * kc * 1000));
%! title (str);
%!
%! % DEMODULATION
%! sd = -sm(1:kc:end, :);
%! b = fir1 (n, 2*[1/kl, 1/kh]); a = 1;
%! sdf = filter (b, a, sd);
%! Sd = fold_psd (psdm (sd, N));
%! Sdf = fold_psd (psdm (sdf, N));
%! f = (0:N/2-1)' * fsr / (kc * N);
%! figure;
%! plot (f, 10 * log10 (Sd), f, 10 * log10 (Sdf));
%! grid on;
%! legend ('input', 'demodulated');
%! title ('demodulation');
%!
%! % COMPARISON
%! figure
%! n0 = 1024;
%! n1 = 2048;
%! sdf = sdf (n/2 : end, :);
%! subplot (4, 1, 1);
%! sf2 = sf(1:kc:end, :);
%! plot (sf2(n0:n1, :));
%! grid on;
%! legend ('orinigal');
%! subplot (4, 1, 2);
%! plot (sm(kc*n0:kc*n1, :));
%! grid on;
%! legend ('single side band');
%! subplot (4, 1, 3);
%! plot (sd(n0:n1, :));
%! grid on;
%! legend ('demodulated');
%! subplot (4, 1, 4);
%! plot (sdf(n0:n1, :));
%! grid on;
%! legend ('demodulated filtered');
%!

