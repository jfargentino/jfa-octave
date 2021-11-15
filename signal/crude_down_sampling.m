function y = crude_down_sampling (x, w)

if (nargin < 2)
    w = 2;
end
[R, C] = size(x);
% if w is scalar, it is the downsampling factor, otherwise it is the window
% used to sum samples, its length is then the downsampling factor.
if (length(w) == 1)
    k = w;
    w = ones(k, 1);
else
    k = length(w);
end
if (mod(R, k) ~= 0)
    x = [x; zeros(k - mod(R, k), 1)];
    [R, C] = size(x);
end
y = zeros(R/k, C);
W = sum(abs(w));
w = repmat(w, 1, R/k);
for c = 1:C
    y(:, c) = sum(reshape(x(:, c), k, R/k)' .* w', 2) / W;
end
