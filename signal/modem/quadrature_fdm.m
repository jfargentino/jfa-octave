function x = quadrature_fdm (y, fc, fsr, fdev, fmax, delay)

%
% function x = quadrature_fdm (y, fc, fsr, fdev, [fmax], [delay])
%
% We have:
%
%         cos(2*pi*fc*t + phi(t)) .* cos(2*pi*fc*(t - dt) + phi(t -dt))
%
% if dt = 1 / (4*fc), we can develop it in:
%
%      cos(phi(t) - phi(t - dt) + pi/2)/2 + cos(4*pi*fc*t + ...)/2
%
% so after a low-pas filter it lasts the 1st term only:
%
%               -sin(phi(t) - phi(t - dt))/2
%
% but, assuming that dt << 1/fmax, we have |phi(t) - phi(t - dt)| << 1, so the
% expression is approximativaly equal to:
%
%                   -(1/2) * dt * dphi(t) / dt
%
% since sin(epsilon) # epsilon, recalling that:
%
%          m(t) = (1/(2*pi*freq_deviation)) * dphi(t) / dt
%
% the expression give us m(t) back.
%
% If dt != 1/(4*fc), the expression is more complicated, but still doable, the
% 2nd equation above becomes:
%
%    cos(phi(t) - phi(t - dt) + 2*pi*fc*dt)/2 + cos(4*pi*fc*t + ...)/2
%
% just develop the 1st term into (dphi is phi(t) - phi(t-dt)):
%
%       cos(dphi)*cos(2*pi*fc*dt)/2 - sin(dphi)*sin(2*pi*fc*dt)/2
%
% with a 1st order approximation we have cos(dphi) # 1 and sin(dphi) # dphi...
% 

[row, col] = size (y);

if (nargin < 6)
    delay = round (fsr / (4*fc));
end

if (nargin < 5)
    % TODO why cutting at fc is not sufficient? I hope fc/2 is OK
    fmax = fc / 2;
end

if (fmax < fsr/2)
    order = 8 / length (fmax);
    [b, a] = butter (order, 2*fmax/fsr);
end

if (nargin < 4)
    fdev = 0.001;
end

y_delayed = [zeros(delay, col); y(1:end-delay, :)];

cd = cos (2*pi*fc*delay/fsr);
sd = sin (2*pi*fc*delay/fsr);
r = - fsr / (sd * delay * pi * fc * fdev);
o = - r * cd / 2;
if (fmax >= fsr/2)
    x = r * y .* y_delayed + o;
else
    x = r * filter (b, a, y .* y_delayed) + o;
end

% TODO why it does not works
%hy = hilbert (y);
%x = filter (b, a, real (hy) .* imag (hy));

%!demo
%! fsr = 144000;
%! fc = 30000;
%! f0 = 70;
%! n = round ((fsr / f0) * 10);
%! 
%! t = (0:n-1)' / fsr;
%! x = sin (2*pi*f0*t);
%! %x = sin (2*pi*(f0/2)*t) + sin (2*pi*f0*t) + sin (2*pi*2*f0*t);
%! %x = ((+n-1):-2:(-n+1))' / n;
%! x = x ./ max (abs (x));
%! 
%! nz = n;
%! z = zeros (nz, 1);
%!
%! dev = 0.01;
%! y = [z; fm(x, fc, fsr, dev); z] + 1.0*randn (n + 2*nz, 1);
%! 
%! band = fc + 1.10*[-(f0 + dev*fc), +(f0 + dev*fc)];
%! order = 4;
%! [b, a] = butter (order, 2*band/fsr);
%! %yd = quadrature_fdm (y, fc, fsr, dev);
%! %yd = quadrature_fdm (filter (b, a, y), fc, fsr, dev);
%! yd = quadrature_fdm (filter (b, a, y), fc, fsr, dev, 8*f0);
%! yd = quadrature_fdm (filter (b, a, y), fc, fsr, dev, fsr);
%! %yd = quadrature_fdm (filter (b, a, y), fc, fsr, dev, [0.75*f0 8.0*f0]);
%!
%! t = (0:n+2*nz-1)' / fsr;
%! %subplot (2, 1, 1)
%! plot (t, [z; x; z], t, yd)
%! %plot (t, yd)
%! %ylim([-2.1 +2.1])
%! %plot (ifreq (yd))
%! %xlim ([t(n/2 - 1024) t(n/2 + 1024)])
%! grid on;
%!
%! XdB = 10*log10 (fold_psd (psd (x)));
%! YdB = 10*log10 (fold_psd (psd (yd(nz+1:nz+n))));
%! f = fsr * (0:(n-1))' / n;
%! %subplot (2, 1, 2);
%! figure
%! plot (f(1:(n/2)), [XdB, YdB])
%! grid on
%! xlim ([0, 4*f0])
%! ylim([-90 +6])
