function xb = partition (x, xb)

if (nargin < 2)
    xb = [];
end
k = 1;

x = sort (x(:));
[dx_max, dx_n] = max (diff (x));

(x(dx_n) + x(dx_n+1)) / 2

x0 = x(1:dx_n);
m0 = mean(x0)
v0 = var(x0)

x1 = x(dx_n+1:end);
m1 = mean(x1)
v1 = var(x1)

%TODO sort of entropy: evaluating the mean and the var of the dataset ->
%     so we have its probality law -> entropy. Make it on the dataset and
%     its two candidate parts, compare and decide

%if (2*(v0 + v1) < vx)
%if ((mean(x1) - max(x0) < k*sqrt(v1)) || (min(x1) - mean(x0) < k*sqrt(v0)))
if ((min(x1) - max(x0) < k*sqrt(v1)) && (min(x1) - max(x0) < k*sqrt(v0)))
    xb = [xb; partition(x0); (x(dx_n) + x(dx_n+1)) / 2; partition(x1)];
end

%!demo
%! nb = 32;
%! x  = [randn(nb, 1)-5; randn(nb, 1); randn(nb, 1)+5];
%! xb = partition (x);
%! plot (x, zeros(length(x)), 'bo')
%! grid on
%! tics ('x', xb);
%!

