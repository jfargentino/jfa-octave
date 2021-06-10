function w = haar (x, K)

v = x;
[r, c] = size (x);
if (nargin < 2)
    K = log2 (r);
end
w = zeros (r, c);
s = sqrt (2.0);

while ((r > 1) && (K > 0))
    r = floor ( r / 2 );
    K = K - 1;
    w(  1:  r, :) = ( v(1:2:2*r-1, :) + v(2:2:2*r, :) ) / s;
    w(r+1:r+r, :) = ( v(1:2:2*r-1, :) - v(2:2:2*r, :) ) / s;
    v(1:2*r, :)   = w(1:2*r, :);
end

%for (k = 1:K)
%    lx = r / 2^k;
%    y(1:lx, :) = x(1:2:2*lx, :) + x(2:2:2*lx, :);
%    y(lx+1:2*lx, :) = x(1:2:2*lx, :) - x(2:2:2*lx, :);
%end

