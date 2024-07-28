function [y, xc, xv] = crest_factor(x, w_sz)
%
% function y = crest_factor(x, w_sz)
%
% Crest factor.
%

[xv, xc] = sliding_var(x, w_sz, 1);
y = xc ./ sqrt(xv);

