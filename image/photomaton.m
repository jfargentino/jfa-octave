function imgout = photomaton (imgin)
%
% function imgout = photomaton (imgin)
% Perform the 'photomaton' transform on an image.
%

imgtmp = padimg (imgin, 2, 2);

[r, c, d] = size (imgtmp);
ul = imgtmp (1:2:end, 1:2:end, :);
ur = imgtmp (1:2:end, 2:2:end, :);
dl = imgtmp (2:2:end, 1:2:end, :);
dr = imgtmp (2:2:end, 2:2:end, :);
imgout = [ ul, ur; ...
           dl, dr ];

%!demo
%! m = imread ('joconde.bmp');
%! m1 = photomaton (m); figure, imagesc (m1)
%! m2 = photomaton (m1); figure, imagesc (m2)
%! m3 = photomaton (m2); figure, imagesc (m3)
%! m4 = photomaton (m3); figure, imagesc (m4)
%! m5 = photomaton (m4); figure, imagesc (m5)
%! m6 = photomaton (m5); figure, imagesc (m6)
%! m7 = photomaton (m6); figure, imagesc (m7)
%! m8 = photomaton (m7); figure, imagesc (m8)
