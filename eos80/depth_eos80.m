function z_m = depth_eos80 (p_bar, latitude_rad, delta_d)
%
% function z_m = depth_eos80 (p_bar, latitude_rad, delta_d)
% 
% Convert the given pressure in bar into a depth in m for the given
% latitude in radians.
% delta_d is the geopotential (or dynamic height) anomaly, defined as the
% integral on p from p0 to pend of the density. (J/m^2)
%
% Achtung, most of the references use dbar as pressure unit, when we're using
% bar...
%

if (nargin < 3)
    delta_d = 0.0;
end
if (nargin < 2)
    latitude_rad = pi / 4;
end

p_bar = p_bar(:);
row = length (p_bar);
latitude_rad = latitude_rad(:)';
col = length (latitude_rad);
p_bar = repmat (p_bar, 1, col);
latitude_rad = repmat (latitude_rad, row, 1);

% Gravity at surface
g0 = gravity_igf67 (latitude_rad, 0.0);

% gamma is the mean vertical gradient of gravity in the ocean, and the radius
% decrease roughly converts into a pressure increase.
% Ref: "UNESCO Technincal Papers in Marine Science N°44"
% TODO 22.26e-6 in "Practical Conversion of Pressure to Depth", Saunders 1980
gamma = 21.84e-6;

c = [ +0.0; ...
      +9.72659e1; ...
      -2.2512e-3; ...
      +2.279e-7; ...
      -1.82e-11 ];
z_m = polyval (flipud(c), p_bar) ./ (g0 + gamma*p_bar/2) + delta_d / 9.8;

%!demo
%!
%! p_bar   = [50, 100:100:1000];
%! lat_deg = [0, 30, 45, 60, 90];
%! % See "UNESCO Technical Papers in Marine Science 44, Algorithms for
%! % Computation of Fundamental Properties of Seawater" p28 to compare results
%! depth_eos80 (p_bar, lat_deg*pi/180)
