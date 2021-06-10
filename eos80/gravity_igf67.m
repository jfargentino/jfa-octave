function g = gravity_igf67 (latitude_rad, z_m)
%
% function g = gravity_igf67 (latitude_rad, z_m)
%
% To get the gravitational acceleration (gravity) of Earth in m/s^2 as modelized
% by the 1967 Geodetic Reference System Formula (aka Helmert's equation,
% aka Clairaut's formula).
%

if (nargin < 2)
    z_m = 0.0;
end

sin_phi  = sin (latitude_rad);
sin_2phi = sin (2*latitude_rad);
g = 9.78031846 * (1.0 ...
                   + 5.3024e-3*(sin_phi.*sin_phi) ...
                   - 5.8e-6*(sin_2phi.*sin_2phi));

% TODO Saunders in "Practical Conversion of Pressure to Depth", 1980 give
% a slightly different formula:
% g = 9.780318 * (1 + 5.3024e-3*sin2_phi - 5.9e-6*sin2_2phi)
% TODO and in "UNESCO Technincal Papers in Marine Science N°44" we have:
% g = 9.780318 * (1 + 5.2788e-3*sin2_phi + 2.36e-5*sin4_phi)
% also found is:
% g = 9.7803185 * (1 + 5.278895e-3*sin2_phi + 2.3462e-5*sin4_phi)

% Free air correction, TODO slab correction
g = g - 3.0835e-6 * z_m;

%!demo
%!
%!g0 = 9.780;
%!latitude_deg = 0:90;
%!g = gravity_igf67 (pi*latitude_deg/180, 0);
%!plot (latitude_deg, g - g0);
%!grid on;
%!xlim([latitude_deg(1), latitude_deg(end)]);
%!title('Gravity acceleration difference IGF67');
