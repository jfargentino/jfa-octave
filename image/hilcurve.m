function [r, c] = hilcurve (n)

if (n <= 0)
   r = 0;
   c = 0;
else
   [r0, c0] = hilcurve (n - 1);
   r = .5 * [-.5+c0, -.5+r0, +.5+r0, +.5-c0 ];
   c = .5 * [-.5+r0, +.5+c0, +.5+c0, -.5-r0 ];
end

