function Sdig = adc (Sana, dynamic, bits_per_sample)
%
% function Sdig = adc (Sana, dynamic, bits_per_sample)
%
%    Simulate the crest cut and the amplitude quantification due to an analog
% to digital converter.
%
% Inputs:
%     -Sana: input signal.
%     -dynamic: adc max input, a value greater than +dynamic will be truncate to
%               +dynamic, and a value less than -dynamic will be truncate to
%               -dynamic.
%     -bits_per_sample: number of bits used for quantification.
%
% Output:
%     -Sdig: a signal of integers samples between +/- 2^(bits_per_sample - 1).
%           

Sdig = Sana;
Sdig (Sdig > +dynamic) = +dynamic;
Sdig (Sdig < -dynamic) = -dynamic;
Sdig = 2^(bits_per_sample - 1) * Sdig / dynamic;
Sdig = round (Sdig);

%!demo
%! Fs = 96000;
%! t  = (0:255) / Fs;
%! sa = 5.5 * sin (2*pi*440*t);
%! d  = 5;
%! nb = 4;
%! sd = adc (sa, d, nb);
%! plot (t, sa, t, 5 * sd / 2^(nb - 1))
%! grid on
