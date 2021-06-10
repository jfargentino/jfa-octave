function y = teager (x)
%
% function y = teager (x)
%
% Non-linear energy-tracking operator, where energy depends on both squares of
% the amplitude and frequency: mechanical consideration is that instantaneous
% energy of an undanmped oscillator is the sum of its kinetic and potential
% energy, which sum as:
%                      E0 = m * (Aw)^2 / 2
% where m is the mass, A and w the oscillation amplitude and pulsation.
%
% Its continuous form is PSY(x) = (x')^2 - x*x''

y = x(2:end-1, :).*x(2:end-1, :) - x(1:end-2, :).*x(3:end, :);

% padded version
%[r, c] = size (x);
%y = [ zeros(1, c); ...
%      x(2:end-1, :).*x(2:end-1, :) - x(1:end-2, :).*x(3:end, :); ...
%      zeros(1, c) ];

%!demo
%! fsr = 192e3;
%! N = 16*65536;
%! t = (0:N-1)' / fsr;
%! s = chirp (t, 1, t(end), fsr / 2, 'linear');
%! f = linspace (0, 1/2, N);
%! plot (f(2:end-1), teager(s));
%! xlim ([0, 1/2]);
%! xlabel ('Normalized frequencies');
%! title ('Kaiser - Teager');
%! grid on;
%!
