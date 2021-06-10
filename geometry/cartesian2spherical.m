function [r, azimuth, inclination] = cartesian2spherical (x, y, z)

if (nargin == 1)
    tmp = x(:);
    x = tmp(1:3:end)';
    y = tmp(2:3:end)';
    z = tmp(3:3:end)';
end

r           = sqrt (x.*x + y.*y + z.*z);
azimuth     = atan2 (y, x);
% atan2 [-pi +pi] but azimuth [0 2pi]
if (azimuth < 0)
    azimuth = azimuth + 2*pi;
end
% acos and inclination [0 pi]
inclination = acos (z ./ r);

if (nargout == 1)
    r = [r; azimuth; inclination];
end

%!demo
%! rtp = cartesian2spherical (1, 0, 0)
%! rtp = cartesian2spherical (0, 1, 0)
%! rtp = cartesian2spherical (0, 0, 1)
%!
%! rtp = cartesian2spherical ([1; 0; 0])
%! rtp = cartesian2spherical ([0; 1; 0])
%! rtp = cartesian2spherical ([0; 0; 1])
%! 
%! rtp = cartesian2spherical ([[1; 0; 0], [0; 1; 0], [0; 0; 1]])
