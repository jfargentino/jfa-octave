function z_m = depth_simple (p_bar, latitude_rad)
%
% function z_m = depth_simple (p_bar, latitude_rad)
% 
% Convert the given pressure in bar into a depth in m for the given
% latitude in radians by using a 2nd order polynomial only.
%
% Ref. "Practical Conversion of Pressure to Depth" by Saunders, 1980
%
% Achtung, most of the references use dbar as pressure unit, when we're using
% bar...
%

if (nargin < 2)
    latitude_rad = pi / 4;
end

p_bar = p_bar(:);
row = length (p_bar);
latitude_rad = latitude_rad(:)';
col = length (latitude_rad);
p_bar = repmat (p_bar, 1, col);
latitude_rad = repmat (latitude_rad, row, 1);

g0 = gravity_igf67 (latitude_rad, 0.0);
c1 = (5.92 + 5.25*sin(latitude_rad).*sin(latitude_rad)) * 1e-2;
c2 = 2.21e-4;
z_m = (10.0 - c1).*p_bar - c2*p_bar.*p_bar;

%!demo
%!
%! p_bar   = 0:1000;
%! lat_deg = 0:90;
%! z1 = depth_simple (p_bar, pi*lat_deg/180);
%! z0 = depth_eos80 (p_bar, pi*lat_deg/180);
%! imagesc (lat_deg, p_bar, z1 - z0);
%! xlabel ('latitude');
%! ylabel ('pressure (bar)');
%! title ('Depth error in m');
%! grid on;
%! colorbar
