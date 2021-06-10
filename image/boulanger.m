function imgout = boulanger (imgin)

imgtmp = padimg (imgin, 2, 2);
[r, c, d] = size (imgtmp);
imgout = zeros (r, c, d);
imgout(1:(r/2), 1:2:c, :) = imgtmp (1:2:end, 1:(c/2), :);
imgout(1:(r/2), 2:2:c, :) = imgtmp (2:2:end, 1:(c/2), :);
imgout((r/2 + 1):end, 1:2:c, :) = imgtmp (end:-2:1, end:-1:(c/2 + 1), :);
imgout((r/2 + 1):end, 2:2:c, :) = imgtmp ((end-1):-2:1, end:-1:(c/2 + 1), :);

%!demo
%! m = imread ('joconde.bmp');
%! m1 = boulanger (m); figure, imagesc (m1)
%! m2 = boulanger (m1); figure, imagesc (m2)
%! m3 = boulanger (m2); figure, imagesc (m3)
%! m4 = boulanger (m3); figure, imagesc (m4)
%! m5 = boulanger (m4); figure, imagesc (m5)
%! m6 = boulanger (m5); figure, imagesc (m6)
%! m7 = boulanger (m6); figure, imagesc (m7)
%! m8 = boulanger (m7); figure, imagesc (m8)
%! m9 = boulanger (m8); figure, imagesc (m9)
%! m10 = boulanger (m9); figure, imagesc (m10)
%! m11 = boulanger (m10); figure, imagesc (m11)
%! m12 = boulanger (m11); figure, imagesc (m12)
%! m13 = boulanger (m12); figure, imagesc (m13)
%! m14 = boulanger (m13); figure, imagesc (m14)
%! m15 = boulanger (m14); figure, imagesc (m15)
%! m16 = boulanger (m15); figure, imagesc (m16)
%! m17 = boulanger (m16); figure, imagesc (m17)
