function x = pdm (y, fc, fsr, dev)

if (nargin < 4)
    dev = 1;
end

[row, col] = size (y);
t = repmat ((0:row-1)' / fsr, 1, col);
y2 = hilbert (y) .* exp (-2*i*pi*fc*t);
x =  unwrap (angle (y2))/(2*pi*dev) + 1/(4*dev);
