function [m, s] = henry (x, nb, k)
%
% For reference, look for:
%    - Q-Q plot (droite de henry in french) qqplot.m
%    - P-P plot ppplot.m
%    - normal probability plot
%
% For normality test, use skewness and kurtosis (both should be tiny) 
%    - D'Agostino's K^2 test
%    - Jarque-Bera test
% or by comparing dataset
%    - Kolmogorov-Smirnov and/or Lilliefors tests
%    - Anderson-Darling test
%
% Shapiro-Wilk test
%

persistent p__t   = (-5:0.001:+5)';
p__NORM_CUM  = @ (x, m, s) 0.5 * (1 + erf ((x - m)/(s*sqrt(2))));
p__NORM_DENS = @ (x, m, s) exp(-((x-m)/s).*((x-m)/s)/2)/(s*sqrt (2*pi));

if (nargin < 3)
    % TODO which one is revelant ?
    %k = round (sqrt (length (x)));
    k = length (x);
end
if (nargin < 2)
    % TODO is it really revelant ?
    nb = k;
end
if (length (nb) == 1)
    [nb, x] = hist (x, nb);
end

[x, n] = sort (x);
nb = nb (n);

p = linspace (0, 1, k + 2)';
p = p(2:end-1);
d = cumsum (nb) / sum (nb);

nk = zeros (k, 1);
xk = zeros (k, 1);
tk = zeros (k, 1);

for n = 1:k
    nk(n) = min (find (d >= p(n)));
    xk(n) = x(nk(n));
    tk(n) = p__t (min (find (p__NORM_CUM (p__t, 0, 1) >= p(n))));
end

l = polyfit (xk, tk, 1);
s = 1 / l(1);
m = -l(2) * s;

if (nargout == 0)
    
    subplot (3, 1, 1);
    plot (xk, tk, 'o', x, polyval (l, x))
    grid on;
    xlim ([x(1), x(end)]);
    
    subplot (3, 1, 2);
    plot (x, nb, ':.', x, sum(nb)*mean (diff (x))*p__NORM_DENS(x, m, s));
    grid on;
    title ('probability density');
    legend ('raw', 'normal');
    xlim ([x(1), x(end)]);
    
    subplot (3, 1, 3);
    plot (x, d, ':.', x, p__NORM_CUM(x, m, s));
    grid on;
    title ('cumulative distribution');
    legend ('raw', 'normal');
    xlim ([x(1), x(end)]);
    
    clear s;
    clear m;
end

%!demo
%!
%! N = 1024;
%! m = 5;
%! s = 3;
%! x = s * randn (N, 1) + m; % Gauss
%! %x = s * rande (N, 1) + m; % Exponantial
%! %x = s * randg ([N, 1]) + m; % Gamma
%! %x = s * randp (m, N, 1);  % Poisson
%! %x = s * rand  (N, 1) + m; % Uniform
%!
%! c = 256;
%! [nn, xx] = hist (x, c);
%! 
%! k = c;
%! [mh, sh] = henry (xx, nn, k)
%! henry (xx, nn, k)

