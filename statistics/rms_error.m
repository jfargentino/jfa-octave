function rmse = rms_error (x, y)
%
% function rmse = rms_error (x, y)
%

[rx, cx] = size (x);
[ry, cy] = size (y);

r = min (rx, ry);
c = min (cx, cy);
xx = x(1:r, 1:c);
yy = y(1:r, 1:c);
rmse = sqrt (sum ((xx - yy).*(xx - yy)) / r);
