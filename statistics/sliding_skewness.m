function y = sliding_skewness (x, w_sz, stp)
%
% function y = sliding_skewness (x, w_sz, stp)
% Sliding skewness of length "w_sz" over "x"
%

if (w_sz <= 0)
   y = NaN;
   return
end

if (nargin < 3)
    stp = 1;
end

y = sliding_fun (x, w_sz, 'skewness', stp);

