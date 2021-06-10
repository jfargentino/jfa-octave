function [xm, it] = kmeans (x, k, it_max, thresh)
%
% function [xm, it] = kmeans (x, k, it_max, thresh)
%
% Partitioning dataset 'x' into 'k' partitions
%
% TODO MATLAB output compatibility: idx, C, sumd, D
% TODO MATLAB input compatibility: no it_max nor thresh but couple of param /
%      value (distance, emptyaction, online phase, start etc...)
% For TODOs above, see http://www.mathworks.fr/fr/help/stats/kmeans.html
%
% TODO Other clustering methods: Expectation-Maximisation, mean shift,
%      hierarchical ...
%

if (nargin < 4)
    thresh = 1e-6; % TODO depending on max (abs (x))
end
if (nargin < 3)
    it_max = k * length (x);
end
if (nargin < 2)
    k = 2;
end

if (k > length(x))
    warning ('can not search for %d means into %d samples', k, length(x))
    xm = [];
    it = 0;
end

x = sort (x(:));

% TODO start with mean at density peak ?
prev_xm = zeros (k, 1);
xm = linspace (x(1), x(end), k + 2);
xm = xm(2:end-1)';
it = 0;
thresh = thresh * abs (x(end));
while ((max (abs (prev_xm - xm)) > thresh) && (it < it_max))
    cum = zeros (k, 1);
    nb  = zeros (k, 1);
    for n = 1:length(x)
        [dmin, kmin] = min (abs (x(n) - xm));
        cum(kmin) = cum(kmin) + x(n);
        nb(kmin)  = nb(kmin) + 1;
    end
    prev_xm = xm;
    xm      = cum ./ nb;
    it      = it + 1;
end

%!demo
%! nb = 32;
%! x  = [randn(nb, 1)-3; randn(nb/2, 1); randn(2*nb, 1)+3];
%! [xm, it_nb] = kmeans (x, 3)
%! %plot (x, zeros(length(x)), 'bo')
%! hist (x, 16)
%! grid on
%! tics ('x', xm);
%!

%!demo
%! nb = 64;
%! x  = [randn(nb, 1)-3; +3];
%! [xm, it_nb] = kmeans (x, 2)
%! plot (x, zeros(length(x)), 'bo')
%! grid on
%! tics ('x', xm);
%!
