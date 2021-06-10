function g = gravity_wgs84 (latitude_rad, z_m)
%
% function g = gravity_wgs84 (latitude_rad, z_m)
%
% To get the gravitational acceleration (gravity) of Earth in m/s^2 as modelized
% by the World Geodetic System 84.
%

if (nargin < 2)
    z_m = 0.0;
end
if (nargin < 1)
    g = 9.80665;
else
    % Ellipsoidal Gravity Formula
    s  = sin (latitude_rad);
    s2 = s .* s;
    g = 9.7803267714 * (1.0 + 1.93185138639e-3*s2) ...
                    ./ sqrt(1.0 - 6.69437999013e-3*s2);
end

% Free air correction, TODO slab correction
g = g - 3.0835e-6 * z_m;

