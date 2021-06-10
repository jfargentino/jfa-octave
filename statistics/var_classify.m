function [xb, x0, x1] = var_classify (x)
%
% function [xb, x0, x1] = var_classify (x)
%
% Partitionning dataset 'x' into 2 classes by minimizing variances. If
% partitioning is not revelant, one subclasse is the dataset, and the other is
% empty.
%
% TODO: any theorical justification?
% TODO: alternative method, partitionning when distance between subclasse
%       barycenters (bounds?) is greater than k*stddev of each subclasse
% TODO: alternative method, search for a density hole, use it as bound and then
%       compare variances before and after. To get the density hole, sort
%       dataset, diff it, the diff maximum is the density hole.
%

xb = min (x)
x0 = [];
v0 = 0
x1 = x;
v1 = var (x1, 0)

next_xb = mean (x);
next_x0 = x(find (x <  next_xb));
next_v0 = var (next_x0, 0)
next_x1 = x(find (x >= next_xb));
next_v1 = var (next_x1, 0)

%while (2*(next_v0 + next_v1) < v0 + v1)
while ((next_v0 + next_v1) < v0 + v1)
    xb = next_xb;
    x0 = next_x0;
    v0 = next_v0;
    x1 = next_x1;
    v1 = next_v1;
    if (v0 > v1)
        % transfer one from x0 to x1
        [m0, k0] = max(next_x0);
        next_x1 = [next_x1; m0];
        next_x0 = [next_x0(1:k0-1); next_x0(k0:end)];
    else
        % transfer one from x1 to x0
        [m1, k1] = min(next_x1);
        next_x0 = [next_x0; m1];
        next_x1 = [next_x1(1:k1-1); next_x1(k1:end)];
    end
    next_xb = (max(next_x0) + min(next_x1)) / 2
    next_v0 = var (next_x0, 0)
    next_v1 = var (next_x1, 0)
end

%!demo
%! nb = 32;
%! p  = [randn(nb, 2) + 5*repmat([1, 0], nb, 1); ...
%!       randn(nb, 2) + 5*repmat([0, 1], nb, 1)];
%! [xb, x0, x1]  = var_classify (p(:, 1));
%! [yb, y0, y1]  = var_classify (p(:, 2));
%! plot (p(:, 1), p(:, 2), 'bo');
%! grid on;
%! tics ('x', xb);
%! tics ('y', yb);

%!demo
%!
%! x = [ -0.37246 -0.45296 -0.41504 -0.37246 -0.45296 -0.41271 -0.32517 ...
%!       -0.36542 -0.36745 -0.37112 -0.41137 -0.37369 -0.37246 -0.45296 ...
%!       -0.41504 -0.37246 -0.45296 -0.41271 -4.94538 -4.98563 -5.01653 ];
%! [y, y0, y1] = var_classify (x')
%!

%!demo
%! nb = 32;
%! x  = [randn(nb, 1)-15; randn(nb, 1); randn(nb, 1)+15];
%! plot (x, diff(x));
%! k0  = 0;
%! [xb, x0, x1] = var_classify (x);
%! %plot (x0, zeros(length(x0)), 'bo', x1, zeros(length(x1)), 'ro')
%! grid on
%! tics ('x', xb);
%!

