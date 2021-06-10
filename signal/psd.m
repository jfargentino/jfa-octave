function S = psd (s)
%
% function S = psd (s)
%
%   To get the power spectral density of signal 's' calculated as
%                    psd(s) = fft(s) x fft(s)* / (N^2)
% where N is the signal length, and * the complex conjugate. Then signal
% variance is sum (psd (s)). Then, the energy conservation says that
%                         var (s) == sum (S).
%
%    If you want to display the psd, you have to add the negative frequencies
% part to the positive ones. You can do:
%      S = S (1:N/2) + S (end:-1:N/2 + 1) for all kind of signals or just
%      S = 2 * S (1:N/2) for real signals only.
% (TODO: any problem on the mean value (bin 0) ?)
%
% Frequency estimation: if we have a peak at index j, we can estimate the true
% frequency F by a power weighting like:
%
%                  ___j+3
%                  \
%                  /__   psd[i] x i x dF
%                     j-3
%    F    =       _______________________       (TODO: To be verified)
%   
%                        ___j+3
%                        \
%                        /__   psd[i]
%                           j-3
%
%
% Its estimated power is then:
% 
%                        ___j+3
%                        \
%                        /__   psd[i]
%                           j-3
%            P   =      _____________        (TODO: To be verified)
%
%                           NPBw
%
% where NPBw is the so called 'Noise Power Bandwith' of the window used.
%
%    For large band signals, to normalize the psd (dB / sqrt Hz) you must
% divide the result per the bandwidth (in dB, remove 10*log10 of the bandwidth)
% which is Fs over the number of points used for the psd, if a uniform window
% is used. For others window we have:
%
%                 estimated power = psd / (dF * NPBw) (TODO: To be verified)
%
% for any temporal window 'w' we have:
% Coherent Gain = mean (w) / max (w)
% Coherent Power Gain = (sum (w))^2 is the same that Coherent Gain
% Noise Power Bandwith = sum (psd (w)) / max (psd (w))
% The Noise Power Bandwith is sometimes called the effective noise bandwith.
%
% ___BUT___ the power correction as defined above DOES NOT WORK !!!
% If we want to have to correct PSD value, it looks like we need to correct it
% with a normalization factor wich is equal to:
%
%                       Fw = sum (w^2 / length(w))
%
% Be aware that if you make a noise like:
%                s = Vrms * randn (N, 1);
% Its power is of Vrms^2 on the bandwith from 0 to Fs/2 - df...
%

l = length (s);
s_hat = fft(s) / l;
S = s_hat .* conj(s_hat);
if (nargout == 0)
    SdB = 10*log10 (abs (fold_psd(S)));
    l = length (SdB);
    f = (0:l-1)' / (2*l);
    plot (f, SdB);
    xlim ([f(1), f(end)]);
    grid on;
    xlabel ('normalized frequency');
    ylabel ('dB / full scale');
    clear S;
end

%!demo
%!
%! N = power (2, 15);
%! NS = N - 3569;
%! f = (0 : NS/2 - 1) / NS;
%! df = 1 / NS;
%!
%! s = sqrt (2) * sin (2 * pi * 0.01 * (0:(N - 1)));
%! S = psd (s, NS);
%! spow = var (s, 1)
%! Spow = sum (S)
%! Sf = S (1:NS/2) + S (end:-1:NS/2 + 1);
%! [p, n] = max (Sf);
%! dn = (-3:+3) + n;
%! ef = sum (Sf(dn) .* (dn - 1) .* df) / sum (Sf(dn));
%! ep = sum (Sf(dn));
%! printf ('When s is a sinus, sum of psd (s) is %0.3f, ', Spow);
%! printf ('variance of s is %0.3f, ', spow);
%! printf ('|sum (psd (s)) - var (s, 1)| = %0.3g\n', abs (Spow - spow));
%! printf ('Frequency [raw, estimated, true]: %g, %g, %g\n', n * df, ef, 0.015);
%! printf ('Estimated power: %g\n', ep);
%! figure,
%! plot (f, 10 * log10 (Sf));
%! grid on
%! xlabel ('Frequency');
%! ylabel ('dB');
%!
%! s = randn (1, N);
%! S = psd (s, NS);
%! spow = var (s, 1);
%! Spow = sum (S);
%! Pmean = mean (S * NS);
%! printf ('When s is a noise, sum of psd (s) is %0.3f, ', Spow);
%! printf ('this give a mean of %0.3f per Hz root, ', Pmean);
%! printf ('variance of s is %0.3f, ', spow);
%! printf ('|sum (psd (s)) - var (s, 1)| = %0.3g and ', abs (Spow - spow));
%! printf ('|mean (psd (s) / PB) - var (s, 1)| = %0.3g\n', abs (Pmean - spow));
%! Sf = S (1:NS/2) + S (end:-1:NS/2 + 1);
%! figure,
%! plot (f, 10 * log10 (Sf * NS));
%! grid on
%! xlabel ('Frequency');
%! ylabel ('dB / sqrt (Hz)');
%!
