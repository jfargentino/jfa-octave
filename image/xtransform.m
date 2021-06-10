function imgout = xtransform (imgin)

imgtmp = padimg (imgin, 2, 2);
[r, c, d] = size (imgtmp);
imgout = zeros (r, c, d);

imgout(3:2:end, 3:2:end, :) = imgtmp(1:2:end-2, 1:2:end-2, :);
imgout(1, 3:2:end, :) = imgtmp(end-1, 1:2:end-2, :);
imgout(3:2:end, 1, :) = imgtmp(1:2:end-2, end-1, :);
imgout(1, 1, :) = imgtmp(end-1, end-1, :);

imgout(2:2:end-2, 3:2:end, :) = imgtmp(4:2:end, 1:2:end-2, :);
imgout(end, 3:2:end, :) = imgtmp(2, 1:2:end-2, :);
imgout(2:2:end-2, 1, :) = imgtmp(4:2:end, end-1, :);
imgout(end, 1, :) = imgtmp(2, end-1, :);

imgout(3:2:end, 2:2:end-2, :) = imgtmp(1:2:end-2, 4:2:end, :);
imgout(1, 2:2:end-2, :) = imgtmp(end-1, 4:2:end, :);
imgout(3:2:end, end, :) = imgtmp(1:2:end-2, 2, :);
imgout(1, end, :) = imgtmp(end-1, 2, :);

imgout(2:2:end-2, 2:2:end-2, :) = imgtmp(4:2:end, 4:2:end, :);
imgout(end, 2:2:end-2, :) = imgtmp(2, 4:2:end, :);
imgout(2:2:end-2, end, :) = imgtmp(4:2:end, 2, :);
imgout(end, end, :) = imgtmp(2, 2, :);

%!demo
%! m = imread ('joconde.bmp');
%! mm = xtransform (m);
%! for n = 1:127
%!    mm = xtransform (mm);
%! end
%! imagesc (mm)

