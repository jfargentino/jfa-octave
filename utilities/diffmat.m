function m = diffmat (x)
%
% Given the vector X, returns the matrice M with "M[r][c] = x(r) - x(c)"
%

x = x(:);
m = repmat (x, 1, length(x));
m = m - m';

