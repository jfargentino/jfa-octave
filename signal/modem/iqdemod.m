function [yi, yq] = iqdemod (x, fc, fsr)

[b, a] = butter (8, fc/fsr);
[row, col] = size (x);
t = repmat ((0:(row-1))' / fsr, 1, col);
yi = filter (b, a, +cos (2*pi*fc*t) .* x);
yq = filter (b, a, -sin (2*pi*fc*t) .* x);

