function a = slinfit (x, w_sz, stp)
%
% function y = slinfit (x, w_sz, stp)
% Find linear fit on each w_sz sized windows, sliding by stp.

if (nargin < 3)
    stp = 1;
end

n0 = 1;
n1 = w_sz;

row = length(x);
a = zeros (ceil (row/stp), 1);
k = 1;

while (n1 <= row)
    p = polyfit((n0:n1)', x(n0:n1), 1);
    a(k) = p(1);
    n0 = n0 + stp;
    n1 = n1 + stp;
    k = k + 1;
end
a = a(1:k-1, :);
