function y = fixed2float (x, nfrac)
%
% function y = fixed2float (x, nfrac)
% convert a fixed point x with nfrac fractionnal bits into a floating point.
%

if (nargin < 2)
    nfrac = 31;
end

if (nfrac > 31)
    error ('%d bits for the fractionnal part is not allowed', nfrac);
    fi = [];
    return;
end

y = x;

% 2-complement negative values
n = find (bitand (x, 2^31));
if (length (n) > 0)
    y(n) = -bitcmp (y(n) - 1, 32);
end

y = y / 2^nfrac;

%!demo
%! fixed2float (float2fixed (+1.0, 31), 31)
%! fixed2float (float2fixed (-1.0, 31), 31)
%! fixed2float (float2fixed (+0.5, 31), 31)
%! fixed2float (float2fixed (-0.5, 31), 31)
%! for n=31:-1:8
%!      n, abs (fixed2float (float2fixed (pi/4, n), n) - pi/4)
%! end
%! for n=31:-1:8
%!      n, abs (fixed2float (float2fixed (e/4, n), n) - e/4)
%! end
