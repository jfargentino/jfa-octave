function [y1, a, b] = ldetrend (y0)
%
% [y1, a, b] = ldetrend (y0)
%
% Remove linear trend from data by finding the 
% best fitting coeficients a,b, that best describe
%                y = ax + b.
% But the a coefficient need to be corrected by the samplerate.
%
% Last modified by fjsimons-at-alum.mit.edu, 15.11.2004
% demo added by jf.argentino-at-free.fr, 2009.03.23
%
y0 = y0 (:);
m = length (y0);
x = 1:m;

% Make Jacobian
A = [x(:) repmat(1,m,1)];

% Invert it
ab = inv (A'*A) * A' * y0;

a = ab (1);
b = ab (2);

% Calculate and remove linear trend
y1 = y0 - a * x(:) - b;

%!demo
%! Fs = 40;
%! T  = (0:1023)' / Fs;
%! x = sin (2 * pi * T);
%! a = 0.25, b = -1,
%! y = x + a * T + b;
%! [z, a0, b0] = ldetrend (y);
%! abs (a - a0 * Fs), abs (b - b0)
%! plot (T, abs (x - z))
%! 
