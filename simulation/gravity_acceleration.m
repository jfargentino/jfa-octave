function g = gravity_acceleration (phi, p)
%
% function g = gravity_acceleration (phi, p)
% ACHTUNG phi is in radians
%
if (nargin == 1)
   p = 0;
end
sin_phi = sin (phi);
sin2_phi = sin_phi .* sin_phi;
pg = [2.3462e-5, 5.278895e-3, 1];
g = 9.7803185 * polyval (pg, sin2_phi) + 1.092e-6 * p;
