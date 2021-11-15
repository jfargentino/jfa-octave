function [y, b] = rup (x, k, tap_nb, margin_percent);

if (nargin < 4)
    margin_percent = 5;
end
if (nargin < 3)
    tap_nb = 64;
end

[R, C] = size(x);
z = zeros(k-1, R);
y = zeros(k*R, C);
for c = 1:C
    y(:, c) = reshape([x(:,c)'; z], k*R, 1);
end

% TODO normalizing dependong on k
b = fir1 (tap_nb, 1/k - margin_percent/100);
y = filter (b, 1, y);

