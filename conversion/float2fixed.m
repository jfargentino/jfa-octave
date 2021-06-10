function y = float2fixed (x, nfrac)
%
% function y = float2fixed (x, nfrac)
% convert floating point x into a fixed point with nfrac fractionnal bits.
%

if (nargin < 2)
    nfrac = 31;
end

if (nfrac > 31)
    error ('%d bits for the fractionnal part is not allowed', nfrac);
    y = [];
    return;
end

y = round (x * (2^nfrac));

% cleeping
my = 2^31;
n = find (y >= +my);
if (length (n) > 0)
    warning ('cleeping %d value(s) to max', length (n));
    y(n) = +my - 1;
end
n = find (y < -my);
if (length (n) > 0)
    warning ('cleeping %d value(s) to min', length (n));
    y(n) = -my;
end

% 2-complements negative values
%n = find (y < 0);
%if (length (n) > 0)
%    y(n) = bitcmp (-y(n), 32) + 1;
%end

% TODO y = int32 (y);

%!demo
%!
%! x = [+2.0, -2.0; ...
%!      +1.0, -1.0; ...
%!      +0.5, -0.5; ...
%!      +0.75, -0.75; ...
%!      +0.125, -0.125];
%!
%! dec2hex (float2fixed (x, 31));
%! dec2hex (float2fixed (x, 23));
%! dec2hex (float2fixed (x, 16));
%! 
%! format long
%! N = 31;
%! y = zeros (N, 1);
%! y(1, 1) = -int32 (float2fixed (0.5, 31));
%! for n = 2:N
%!     tmp = bitshift (int64(int64(y(1)) * int64(y(n-1))), -31);
%!     y(n, 1) = -int32(tmp);
%! end 
%! 1.0 + fixed2float (sum (y), 31)
%! y
