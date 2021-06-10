function [p, x_sorted] = pdensity (x)
%
% function [p, x_sorted] = pdensity (x)
%
% Compute the density of a dataset.
%
% TODO this is something i've tried but no there's maths behind
%

x_sorted = sort(x(:));
p = zeros (length(x), 1);
p(1) = 1 / (x_sorted(2) - x_sorted(1));
p(2:end-1) = 2*ones(length(x)-2, 1) ./ (x_sorted(3:end) - x_sorted(1:end-2));
p(end) = 1 / (x_sorted(end) - x_sorted(end-1));
p = p / sum(p);

%!demo
%! nb = 32;
%! x = [randn(nb, 1)-4; randn(nb, 1); randn(nb, 1)+4];
%! [d, x] = pdensity (x);
%! plot (x, zeros(length(x), 1), 'ro', x, log(d))
%!

%!demo
%! nb = 1024;
%! x = randn(nb, 1);
%! y = 4*(2*rand(nb, 1) - 1);
%! [dx, x] = pdensity (x);
%! [dy, y] = pdensity (y);
%! plot (x, log(dx), y, log(dy))
%!
