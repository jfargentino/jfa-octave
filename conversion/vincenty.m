function [latitude1, longitude1] = vincenty (latitude0, longitude0, ...
                                             azimuth, distance)
%
%function [latitude1, longitude1] = vincenty (latitude0, longitude0, ...
%                                             azimuth, distance)
%
% Direct Vincenty evaluates latitude and longitude of a point given latitude
% and longitude of a reference, an azimuth and a distance from this reference.
% All coordinates and azimuth are in radians, distance in meters.
%

if (nargin < 5)
    % 1e-12 corresponds to approximately 0.06mm
    dsigma_min = 1e-12;
end
p__LOOP_MAX = 64;

% Constantes %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% length of semi-major axis of the ellipsoid (radius at equator)
a_WGS84 = 6378137.0; % = a_GRS80
a_GRS80 = a_WGS84;
% flattening of the ellipsoid
f_WGS84 = 1.0 / 298.257223563;
f_GRS80 = 1.0 / 298.2572221088;
% Choose GRS80 or WGS84
a = a_WGS84;
f = f_WGS84;
% length of semi-minor axis of the ellipsoid (radius at the poles)
b = (1.0 - f) * a;

% Process %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tangeante of the reduced latitude
tan_u0 = (1.0 - f) * tan (latitude0);
u0     = atan (tan_u0);
cos_u0 = cos (u0);
sin_u0 = sin (u0);

cos_az = cos (azimuth);
sin_az = sin (azimuth);

sigma1 = atan2 (tan_u0, cos_az);
sin_alpha    = cos_u0 * sin_az;
cos_alpha_sq = (1.0 - sin_alpha)*(1.0 + sin_alpha);
u_sq         = cos_alpha_sq * (a^2 - b^2) / b^2;

% TODO test Vincenty's simplifications:
% dum = sqrt (1.0 + u_sq);
% k1 = (dum - 1.0) / (dum + 1.0);
% big_a = (1.0 + (k1^2) / 4.0) / (1.0 - k1);
% big_b = k1 * (1.0 - 3.0*(k1^2)/8.0);
big_a = 1.0 + u_sq*(4096.0 + u_sq*(-768.0 + u_sq*(320.0 - 175.0*u_sq)))/16384.0;
big_b = u_sq * (256.0 + u_sq*(-128.0 + u_sq*(74.0 + 47.0*u_sq))) / 1024.0;

% iterations
prev_sigma = 0.0;
sigma = distance / (b * big_a);
loop_nb = p__LOOP_MAX;
while ((abs (sigma - prev_sigma) >= dsigma_min) && (loop_nb > 0))
    two_sigma_m = 2.0 * sigma1 + sigma;
    cos_two_sigma_m = cos (two_sigma_m);
    sin_sigma = sin (sigma);
    dsigma = -big_b * cos_two_sigma_m ...
                    * (-3.0 + 4.0*sin_sigma^2) ...
                    * (-3.0 + 4.0*cos_two_sigma_m^2) / 6.0;
    dsigma = cos(sigma)*(-1.0 + 2.0*cos_two_sigma_m^2) + dsigma;
    dsigma = 0.25 * big_b * dsigma;
    dsigma = cos_two_sigma_m + dsigma;
    dsigma = big_b * sin_sigma * dsigma;
    prev_sigma = sigma;
    sigma      = distance / (b * big_a) + dsigma;
end
if (loop_nb == 0)
    warning ('directe Vincenty does not converge after %d iterations, (%f)', ...
             p__LOOP_MAX, abs (sigma - prev_sigma));
end

cos_sigma = cos (sigma);
sin_sigma = sin (sigma);
lambda = atan2 (sin_sigma*sin_az, cos_u0*cos_sigma - sin_u0*sin_sigma*cos_az);
c = f * cos_alpha_sq * (4.0 + f*(4.0 - 3.0*cos_alpha_sq)) / 16.0;

% tada... and the results are:
latitude1 = atan2 (sin_u0*cos_sigma + cos_u0*sin_sigma*cos_az, ...
                   (1.0-f)*sqrt (sin_alpha^2 ...
                                   + (sin_u0*sin_sigma ...
                                            - cos_u0*cos_sigma*cos_az)^2));
longitude1 = c * cos_sigma * (-1.0 + 2.0*cos_two_sigma_m);
longitude1 = cos_two_sigma_m + longitude1;
longitude1 = c * sin_sigma * longitude1;
longitude1 = sigma + longitude1;
longitude1 = -(1.0 - c) * f * sin_alpha * longitude1;
longitude1 = lambda + longitude0 + longitude1;

%!demo
%!
%! lat0 =  -37 - 57/60 -  3.72030/3600;
%! lon0 = +144 + 25/60 + 29.52440/3600;
%! az   = 306. + 52/60 + 5.37/3600;
%! d    = 54972.217;
%! % must give lat1 = -37.6528211388889 and lon1 = 143.926495527778
%! % see http://www.ga.gov.au/geodesy/datums/vincenty_direct.jsp
%! [lat1, lon1] = vincenty (pi*lat0/180, pi*lon0/180, pi*az/180, d);
%! lat1 = 180*lat1/pi
%! lon1 = 180*lon1/pi
%!
