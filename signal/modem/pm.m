function y = pm (x, fc, fsr, dev)
%
% function y = pm (x, fc, fsr, dev)
%
% To phase modulate a carrier wave at 'fc' with signal 'x'.
%
% - x: the message signal (the 'modulating')
% - fc: the carrier frequency in Hz
% - fsr: the sampling rate
% - dev: normalized modulation index
%
% The modulation index h in radians is defined as the peak phase deviation,
% thus we have:
%                       h = 2*pi*dev*max(abs(x))
%

if (nargin < 4)
    dev = 1;
end

[row, col] = size (x);
t = repmat ((0:(row-1))' / fsr, 1, col);
y = sin (2*pi*fc*t + 2*pi*dev * x);

%!demo
%!
%! fsr = 144000;
%! fc = 20000;
%! dev = 0.125;
%! n = 16384;
%! f0 = 100;
%!
%! t = (0:n-1)' / fsr;
%! %x = 1.0 * ones (n,1);
%! %x = ((+n-1):-2:(-n+1))' / n;
%! %x = cos (2*pi*f0*t);
%! x = cos (2*pi*f0*t/10) + cos (2*pi*f0*t) + cos (2*pi*10*f0*t);
%! x = x / max (abs (x));
%! y = pm (x, fc, fsr, dev);
%!
%! subplot (3, 1, 1);
%! plot (t, x, t, y);
%! %plot (t, x);
%! xlim ([t(1), t(end)]);
%! grid on;
%! %legend ('x', 'y');
%!
%! subplot (3, 1, 2);
%! X = psd (x);
%! Y = psd (y);
%! f = fsr * (0:n-1)' / n;
%! f = f(1:end/2);
%! plot (f, 10*log10 (X(1:n/2)), f, 10*log10 (Y(1:n/2)))
%! xlim ([f(1), f(end)]);
%! grid on
%!
%! subplot (3, 1, 3);
%! yd = pdm (y, fc, fsr, dev);
%! yd_error = x - yd;
%! plot (t, yd_error);
%! %plot (t, [x, yd]);
%! grid on
%! n0 = n/2 - 4096; n1 = n/2 + 4096;
%! %xlim ([t(n0), t(n1)]);
%! mean (yd(n0:n1) - x(n0:n1))
%! %ylim ([min(yd_error(n0:n1)), max(yd_error(n0:n1))])
%! %ylim ([-1, +1])
%! 
