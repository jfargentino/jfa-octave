function p_bar = pressure_simple (z_m, latitude_rad)

if (nargin < 2)
    latitude_rad = pi/4; % maybe 0 ?
end
if (nargin < 1)
    z_m = 1;
end

Cphi = (5.92 + 5.25*sin(latitude_rad).*sin(latitude_rad)) * 1e-2;
a = 2.21e-4;
b = Cphi - 10;
delta = b.*b - 4*a*z_m;
p_bar = (-b - sqrt (delta)) / 4.42e-4;

