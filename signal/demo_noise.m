clear all;
close all;

Ntot = 2^20;
Nfft = 2^14;
a4   = 4;

s4 = sqrt (a4) * randn (Ntot, 1);
%s4 = colorizedNoise ([0:0.1:0.5], a4 * ones (6, 1), Ntot);

printf ('variance of sqrt (%f) x rand = %f\n', a4, var (s4));
printf ('Noise dynamic (max - min) divided by its RMS value: %f\n', ...
	(max (s4) - min (s4)) / sqrt (var (s4)));
S4 = psdm (s4, Nfft);
printf ('sum (psd (s4, %d)) = %f\n', Nfft, sum (S4));
printf ('%d x mean (psd (s4, %d)) = %f\n', Nfft, Nfft, Nfft * mean (S4));
plot (S4 * Nfft);
S4 = psdm (s4, Nfft / 4);
printf ('sum (psd (s4, %d)) = %f\n', Nfft / 4, sum (S4));
printf ('%d x mean (psd (s4, %d)) = %f\n', Nfft/4, Nfft/4, Nfft*mean (S4)/4);
hold on, plot (S4 * Nfft / 4, '2'); hold off

