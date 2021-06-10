function z = sliding_diff (x, y, stp)
%
% function z = sliding_diff (x, y, stp)
% makes sliding "y" along "x" by "stp" steps
%

if (nargin < 3)
    stp = 1;
end

[row, col] = size (x);
sz = length (y);
z = zeros (ceil (row/stp) - 2*sz, col);
n0 = 1;
n1 = sz;
k = 1;
y = repmat (y, col);
while (n1 <= row)
    z(k) = sum (abs (x(n0:n1) - y));
    n0 = n0 + stp;
    n1 = n1 + stp;
    k = k + 1;
end

