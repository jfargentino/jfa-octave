function [x, n] = adapted_filter (S, Sref)
x      = fxcorr (S, Sref);
[m, n] = max (x);
n      = n - length (Sref);
