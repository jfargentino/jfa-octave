function [x, y, z] = spherical2cartesian (r, azimuth, inclination)

if (nargin == 1)
    tmp = r(:);
    r           = tmp(1:3:end)';
    azimuth     = tmp(2:3:end)';
    inclination = tmp(3:3:end)';
end

x = r(:)' .* sin(inclination(:)') .* cos(azimuth(:)');
y = r(:)' .* sin(inclination(:)') .* sin(azimuth(:)');
z = r(:)' .* cos(inclination(:)');

if (nargout == 1)
    x = [x; y; z];
end

%!demo
%! xyz = randn (3, 1);
%! sph = cartesian2spherical (xyz)
%! xyz2 = spherical2cartesian (sph);
%! xyz - xyz2
