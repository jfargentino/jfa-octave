function y = fm (x, fc, fsr, fdev)
%
% function y = fm (x, fc, fsr, fdev)
%
% Frequency modulation, it modulates a carrier at 'fc' by signal 'x' sampled
% at 'fsr'. 'fdev' is the peak frequency deviation relative to the carrier
% frequency, then the excursion DeltaF = fdev * fc, and then modulation index
% is given by h = (fc*fdev) / Fmax where Fmax is the maximum frequency of the
% modulating signal 'x', which _MUST_ be bounded by [-1 +1].
%
% if h << 1: narrowband FM, bandwith # 2Fmax
% if h >> 1: wideband FM, bandwith # 2Fdelta (?)
%
% Carson's rule: 98% of the power is within bandwith Bt = 2*(DeltaF + Fmax)
% around fc
%

if (nargin < 4)
    fdev = 0.001;
end

%[row, col] = size (x);
%t = repmat ((0:(row-1))' / fsr, 1, col);
%y = sin (2*pi*fc*t + 2*pi*fdev * fc*cumsum(x)/fsr);

xx = fc*cumsum(x)/fsr;
y = pm (xx, fc, fsr, fdev);

%!demo
%!
%! fsr = 144000;
%! fc = fsr/7;
%! dev = 0.125;
%! n = 16384;
%!
%! t = (0:n-1)' / fsr;
%! %x = 1.0 * ones (n,1);
%! %x = ((+n-1):-2:(-n+1))' / n;
%! x = sin (2*pi*50*t) + sin (2*pi*500*t) + sin (2*pi*5000*t);
%! x = x / max (abs (x));
%! y = fm (x, fc, fsr, dev) + 0.5 * randn (size(x));
%!
%! subplot (3, 1, 1);
%! %plot (t, x, t, y);
%! plot (t, x);
%! xlim ([t(1), t(end)]);
%! grid on;
%! %legend ('x', 'y');
%!
%! order = 8;
%! [b, a] = butter (8, 2*(fc + [-5000-dev*fc, +5000+dev*fc]) / fsr);
%!
%! subplot (3, 1, 2);
%! X = psd (x);
%! Y = psd (filter (b, a, y));
%! %Y = psd (y);
%! f = fsr * (0:n-1)' / n;
%! f = f(1:end/2);
%! plot (f, 10*log10 (X(1:n/2)), f, 10*log10 (Y(1:n/2)))
%! xlim ([f(1), f(end)]);
%! grid on
%!
%! subplot (3, 1, 3);
%! yd = fdm (y, fc, fsr, dev);
%! yd = fdm (filter (b, a, y), fc, fsr, dev);
%! yd = [yd(order+1:end, :); zeros(order, 1)];
%! yd_error = x - yd;
%! %plot (t, yd_error);
%! plot (t, [x, yd]);
%! grid on
%! n0 = n/2 - 4096; n1 = n/2 + 4096;
%! xlim ([t(n0), t(n1)]);
%! %ylim ([min(yd_error(n0:n1)), max(yd_error(n0:n1))])
%! %ylim ([-1, +1])
%! %plot (t, log10(psd(yd)));
%! 
