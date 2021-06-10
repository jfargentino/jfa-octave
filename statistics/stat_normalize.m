function [s_norm, mean_s, var_s] = stat_normalize (s)
%
% function [s_norm, mean_s, var_s] = stat_normalize (s)
%
% return s_norm = (s - mean (s)) / sqrt (var (s))
%
mean_s = mean (s);
var_s  = var (s);
s_norm = (s - mean_s) / sqrt (var_s);
