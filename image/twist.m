function imgout = twist (imgin);
[r,c,d] = size (imgin);
imgout = zeros(r, c, d);
imgout(:, :, :) = imgin([end, 1:end-1], [2:end, 1], :); 
