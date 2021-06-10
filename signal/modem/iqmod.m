function y = iqmod (x, fc, fsr)

[row, col] = size (x);
t = repmat ((0:(row-1))' / fsr, 1, col);
yi = +cos (2*pi*fc*t);
yq = -sin (2*pi*fc*t);
y  = (x/sqrt(2)) .* (yi + yq);

