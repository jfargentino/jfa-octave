function sf = sliding_mfreq (x, sz, stp, fsr)

if (nargin < 4)
    fsr = 1;
end
if (nargin < 3)
    stp = 1;
end

n0 = 1;
n1 = sz;
[row, col] = size (x);
sf = zeros (ceil (row/stp), col);
k = 1;
while (n1 <= row)
    sf(k, :) = mfreq (x(n0:n1, :), fsr);
    n0 = n0 + stp;
    n1 = n1 + stp;
    k = k + 1;
end
sf = sf (1:k-1, :);
