function y = sliding_max (x, w_sz, stp)

if (w_sz <= 0)
   y = NaN;
   return
end

if (nargin < 3)
    stp = 1;
end

y = sliding_fun (x, w_sz, 'max', stp);

%!demo
%! x = (-10:10)';
%! sliding_max (x, 3, 1)'
%! sliding_max (x, 3, 2)'
%! sliding_max (x, 3, 3)'
%! sliding_max (x, 10, 1)'
%! sliding_max (x, 10, 5)'
%! sliding_max (x, 21, 1)'
%! sliding_max (x, 21, 5)'

