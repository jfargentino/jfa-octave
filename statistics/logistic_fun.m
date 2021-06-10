function x = logistic_fun (n, a, x0)
%
% function x = logistic_fun (n, a, x0)
%
% Logistic optim ?
%
if (nargin < 3)
    x0 = randn (1);
end
if (nargin < 2)
    a = randn (1);
end
if (n < 1)
    x = [];
    return;
end

a  = a(:)';
ka = length (a);
x0 = x0(:)';
kx = length (x0);

if ((ka == 1)&&(kx == 1))
    x = [x0; zeros(n - 1, 1)];
elseif (ka == 1)
    x = [x0; zeros(n - 1, kx)];
    a = repmat (a, 1, kx);
elseif (kx == 1)
    x = [repmat(x0, 1, ka); zeros(n - 1, ka)];
elseif (ka ~= kx)
    x = [];
    return;
else
    x = [x0; zeros(n - 1, ka)];
end

for (nn = 2:n)
    x(nn, :) = a.*x(nn-1, :).*(1 - x(nn-1, :));
end

%!demo
%! n  = 128;
%! step = 0.001;
%!
%! x0 = 0.5;
%! a = 0.1 : step : 1;
%! x = logistic_fun(n, a, x0);
%! figure, plot (x);
%!
%! x0 = 0.5;
%! a = 1.1 : step : 2;
%! x = logistic_fun(n, a, x0);
%! figure, plot (x);
%!
%! x0 = 0.5;
%! a = 2.1 : step : 3;
%! x = logistic_fun(n, a, x0);
%! figure, plot (x);
%!
%! x0 = 0.5;
%! a = 3 : step : (1 + sqrt(6));
%! x = logistic_fun(n, a, x0);
%! figure, plot (x);
%!
%! x0 = 0.5;
%! a = (1 + sqrt(6)) : step : 3.54;
%! x = logistic_fun(n, a, x0);
%! figure, plot (x);
%!
%! x0 = 0.5;
%! a = 3.54 : step : 3.56;
%! x = logistic_fun(n, a, x0);
%! figure, plot (x);
%!
%! x0 = 0.5;
%! a = 3.57 : step : 3.58;
%! x = logistic_fun(n, a, x0);
%! figure, plot (x);
%!
%! x0 = 0.5;
%! a = 4 : step : 5;
%! x = logistic_fun(n, a, x0);
%! figure, plot (x);
