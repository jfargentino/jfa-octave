function [y, xc] = sliding_var (x, w_sz, stp)
%
% function [y, xc] = sliding_var (x, w_sz, stp)
%
% Sliding variance of length "w_sz" over "x". 2nd output is the centered version
% of 'x'.
%
% TODO unbiased
%

if (nargin < 3)
    stp = 1;
end

[r, c] = size(x);
xc = x(w_sz:end, :) - sliding_mean(x, w_sz, stp);
xc2 = xc .* xc;
y = sliding_mean( [ zeros(w_sz-1, c); xc2 ], w_sz );

