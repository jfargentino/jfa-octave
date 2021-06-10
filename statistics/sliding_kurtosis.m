function y = sliding_kurtosis (x, w_sz, stp)
%
% function y = sliding_kurtosis (x, w_sz, stp)
% Sliding kurtosis of length "w_sz" over "x"

if (w_sz <= 0)
   y = NaN;
   return
end

if (nargin < 3)
    stp = 1;
end

y = sliding_fun (x, w_sz, 'kurtosis', stp);

