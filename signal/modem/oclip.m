function y = oclip (x, offset, bounds, normalize)

if (nargin < 4)
   normalize = 0;
end
if (nargin < 3)
   bounds = 1;
end
if (nargin < 2)
   offset = 0;
end

if (length (bounds) == 1)
   hi = abs (bounds);
   lo = -hi;
else
   hi = max (bounds);
   lo = min (bounds);
end

y = x;
y(find (y > hi)) = hi; 
y(find (y < lo)) = lo;
if (normalize ~= 0)
   y = y / normalize;
end
if (offset ~= 0)
   y = y + offset;
end

%!demo
%! n = 128;
%! t = (0:n-1)' / n;
%! offset = 0.125;
%! hi = 1.1;
%! lo = -0.9;
%! x = 1.2 * sin (2 * pi * t);
%! x1 = oclip (x);
%! x2 = oclip (x, offset);
%! x3 = oclip (x, 0, [hi, lo]);
%! x4 = oclip (x, offset, [hi, lo]);
%! o = offset * ones (n, 1);
%! h = hi * ones (n, 1);
%! l = lo * ones (n, 1);
%! figure; 
%! plot (t, x, t, x1, t, x2, t, x3, t, x4, t, o, t, h, t, l);
%! title ('no normalization');
%! legend ('original', '[-1 +1], no offset', '[-1 +1], +0.125', ...
%!         '[-0.9 +1.1], no offset', '[-0.9 +1.1], +0.125', ...
%!         'offset', 'hi', 'lo');
%! grid on
%! x1 = oclip (x, 0, 1, 1);
%! x2 = oclip (x, offset, 1, 1);
%! x3 = oclip (x, 0, [hi, lo], 1);
%! x4 = oclip (x, offset, [hi, lo], 1);
%! figure;
%! plot (t, x, t, x1, t, x2, t, x3, t, x4, t, o, t, h, t, l);
%! title ('normalization');
%! legend ('original', '[-1 +1], no offset', '[-1 +1], +0.125', ...
%!         '[-0.9 +1.1], no offset', '[-0.9 +1.1], +0.125', ...
%!         'offset', 'hi', 'lo');
%! grid on
%!
