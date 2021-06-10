function y = sliding_min (x, w_sz, stp)

if (w_sz <= 0)
   y = NaN;
   return
end

if (nargin < 3)
    stp = 1;
end

y = sliding_fun (x, w_sz, 'min', stp);

%!demo
%! x = (-10:10)';
%! sliding_min (x, 3, 1)'
%! sliding_min (x, 3, 2)'
%! sliding_min (x, 3, 3)'
%! sliding_min (x, 10, 1)'
%! sliding_min (x, 10, 5)'
%! sliding_min (x, 21, 1)'
%! sliding_min (x, 21, 5)'

