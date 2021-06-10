function y = sliding_var (x, w_sz, stp)
%
% function y = sliding_var (x, w_sz, stp)
% Sliding variance of length "w_sz" over "x"
% TODO unbiased

if (nargin < 3)
    stp = 1;
end

y = sliding_fun (x, w_sz, 'var', stp);
