function h = normal_entropy (x)

% normal (gaussian) distributions
h = log (2*pi*e*var(x)) / 2;

% TODO Cauchy-Lorentz distributions (no mean nor variance): evaluates the
%      dataset interquartile range, take its half as gamma then
%      h = log(gamma) + log(4*pi)

% TODO Levy distributions (mean and variance are Inf): evaluates its scale c
%      (but how to do so from a dataset?), then
%      h = (1 + 3*gamma + log(16*pi*c^2)) / 2 where gamma is the Euler's
%      constant lim (sum(ones(n, 1)./(1:n)') - log(n)) when n reaches Inf

% TODO measures of scale: IQR (interquartile range) and MAD
%      (median absolute deviation)
