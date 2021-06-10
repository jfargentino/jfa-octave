function d = depth (p, phi, deltaD)

% ACHTUNG phi is in radians

if (nargin < 2)
   % A latitude where g is mean
   phi = pi / 4;
end
if (nargin < 3)
   % Correction which depends on temperature and salinity
   deltaD = 0;
end

depth_poly = [-1.82e-15, 2.279e-10, -2.2512e-5, 9.72659, 0];
d = polyval (depth_poly, p) ./ gravity_acceleration (phi, p) + deltaD / 9.8;
