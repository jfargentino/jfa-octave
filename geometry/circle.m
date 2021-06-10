function [x, y] = circle (c, r, step)
%
% function [x, y] = circle (c, r, step)
%
% To generate x and y value of a cercle of center c, and radius r
% If no output, plot it.
%
if (nargin < 3)
    step = 100;
end

t = (0 : 2*pi/step : 2*pi)';
x = r * cos (t) + c(1);
y = r * sin (t) + c(2);
if (nargout == 0)
    plot (x, y, c(1), c(2), '+b');
    clear x;
    clear y;
end
