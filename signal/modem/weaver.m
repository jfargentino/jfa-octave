function y = weaver (x, wc, wm);

norder = 64;

if (nargin < 3)
   wm = wc / 4;
end
w2 = wc + wm;
x = oclip (x);
b = fir1 (norder, mean ([wm, wc/2])); a = 1;
yi = am (filter (b, a, am (x, wm)), w2);
yq = am (filter (b, a, am (x, wm, -pi/2)), w2, pi/2);
y =  -yi +yq;

%!demo
%! % kc Sampling rate to carrier ratio => Fc = Fsr / kc, the less is the better
%! % to easily remove the carrier, but min is 3 due to Nyquist
%! kc = 3;
%! kl = 80/3; % carrier to lowest freq ratio => Fl = Fc / kl
%! kh = 8/3; % carrier to highest freq ratio => Fh = Fc / kh
%! m = 1;
%! n = 256; % Filter order
%! N = 32768;
%! [s, fsr] = audioread ('japanese_telecom.wav');
%! s = mean (s, 2);
%!
%! % MODULATION
%! b = fir1 (n, 2*[1/(kl*kc), 1/(kh*kc)]); a = 1;
%! sf = filter (b, a, s);
%! sm = weaver (sf, 1/kc, mean ([1/(kc*kl), 1/(kc*kh)]));
%! %sm = weaver (sf, kc);
%! Sf = fold_psd (psdm (sf, N));
%! Sm = fold_psd (psdm (sm, N));
%! f = (0:N/2-1)' * fsr / N;
%! figure;
%! plot (f, 10 * log10 (Sf), f, 10 * log10 (Sm));
%! grid on;
%! legend ('input', 'upper single side band');
%! str = sprintf ('Sample rate: %.1fkHz, Carrier: %.1fkHz, band: %.1fkHz - %.1fkHz', fsr / 1000, fsr / (kc * 1000), fsr / (kl * kc * 1000), fsr / (kh * kc * 1000));
%! title (str);

