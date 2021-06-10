function y = atypicity (x, n);
%
% function y = atypicity (x, n);
%
% Returns a sliding 'atypicity' indicator on x. Atypicity, aka crest factor
% is the mean / std dev for a n-length sliding windows.
% Any points over 3 are outliers, or the distribution is not gaussian.
%

stp = 1;
y = (x(n:end, :) - sliding_mean (x, n, stp)) ...
                ./ sqrt (sliding_var (x, n, stp, 1));

% p(x<=x0) = (1 + erf((x-mx) / (sx*sqrt(2)))) / 2;

%!demo
%!
%! n = 256;
%! N = 33*n;
%! m = 0;
%! s = 1;
%! xn = s * randn (N, 1) + m; % Gauss
%! xe = s * rande (N, 1) + m; % Exponantial
%! xu = s * rand  (N, 1) + m; % Uniform
%! xl = lognrnd(0, 0.5, N, 1);
%! xc = cauchy_rnd (0, 1, N, 1);
%! %xp = s * randp (m, N, 1);  % Poisson
%! %xg = s * randg ([N, 1]) + m; % Gamma
%! %x = [xn, xe, xg, xp, xu, xc];
%! x = [xn, xe, xu, xl, xc];
%! dx = max(x) - min(x)
%!
%! y = atypicity (x, n);
%! my = max(y)
%!
%! subplot (2, 1, 1);
%! plot (x);
%! xlim ([1, N-n]);
%! legend ('gauss', 'exp', 'uniform', 'log norm', 'cauchy');
%! grid on
%! yticks ([min(x), max(x)]);
%!
%! subplot (2, 1, 2);
%! plot (y);
%! xlim ([1, N-n]);
%! legend ('gauss', 'exp', 'uniform', 'log norm');
%! grid on
%! yticks ([min(y), max(y)]);

