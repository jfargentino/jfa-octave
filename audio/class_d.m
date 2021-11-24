function y = class_d (x, up)

if (nargin < 2)
    up = 16;
end

[r, c] = size (x);
y = zeros (up * r, c);

xd = round (up * x);
for (k = 1:r)
    k0 = (k-1)*up + 1;
    y(k0:k0+abs(xd(k))-1) = sign(x(k));
end

