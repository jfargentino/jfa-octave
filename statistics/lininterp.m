function y = lininterp (x, n, last)
%
% function y = lininterp (x, n, last)
% Linear interpolation between each values of set "x" by a factor "n",
% until "last" value
%
if (nargin < 3)
   last = x (end);
end

if (nargin < 2 )
   n = 2;
end

y = zeros (length (x(:)), n+1);
y (:, 1) = x (:);
y (1:end-1, end) = x (2:end);
y (end, end) = last;
incr = (y (:, end) - y (:, 1)) / n;
for (k = 2 : n)
   y (:, k) = y (:, 1) + (k - 1) * incr;
end
y = y (:, 1:n)';
y = y (:);
