function md = mean_dev (x)
%
% function md = mean_dev (x)
% Compute the mean deviation of "x" as the mean of the absolute difference
% between each element of "x" and its mean.
% It is less efficient in estimating the std dev, but more robust in regard
% to erroneous data. For a normal distibution of std dev s, we have
%                    mean deviation = s * sqrt (2/pi)
% Also known as "mean absolute deviation"
%

md = mean (abs (x - mean(x)));

%!demo
%! n = 32768;
%! x = randn (n, 1);
%! md = mean_dev (x)
%! sd = sqrt (var (x))
%! (sd / md)^2 - pi/2 
