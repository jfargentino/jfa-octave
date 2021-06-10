function imgout = hiltrans (imgin)

[r, c, d] = size (imgin);
l2n = log2 (length (imgin))
[nr, nc] = hilcurve (l2n);
nr = pow2 (l2n) * nr + pow2 (l2n-1) + .5;
nc = pow2 (l2n) * nc + pow2 (l2n-1) + .5;
imgout = zeros (r, c, d);
imgout = imgin (nr, nc, :);
for k = 1:length(nr)
   rr = floor (k / nr) + 1;
   cc = mod (k, c + 1);
   imgout(rr, cc, :) = imgin(nr(k), nc(k), :);
end
