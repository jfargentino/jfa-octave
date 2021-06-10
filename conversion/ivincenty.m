function [azimuth, distance] = ivincenty (latitude0, longitude0, ...
                                          latitude1, longitude1, ...
                                          dlambda_min)
%
% function [azimuth, distance] = ivincenty (latitude0, longitude0, ...
%                                           latitude1, longitude1, ...
%                                           dlambda_min)
%
% Inverse Vincenty evaluates distance in m and azimuth in radians of 2 points
% given their geodesic coordinates in radians. The azimuth is from
% P0(latitude0, longitude0) to P1(latitude1, longitude1).
%
% For more details, see "Direct and Inverse Solutions of Geodesics on the
% Ellipsoid with Application of Nested Equations" (T. Vincenty) from "Survey
% Review XXII.176" of April 1975.
%

if (nargin < 5)
    % 1e-12 corresponds to approximately 0.06mm
    dlambda_min = 1e-12;
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
% reduced latitudes
u0 = atan ((1.0 - f) * tan (latitude0));
u1 = atan ((1.0 - f) * tan (latitude1));
sin_u0 = sin (u0);
cos_u0 = cos (u0);
sin_u1 = sin (u1);
cos_u1 = cos (u1);
% difference of longitude (positive east)
dl = longitude1 - longitude0;

% iterations
prev_lambda = 0.0;
lambda = dl;
sin_lambda = sin (lambda);
cos_lambda = cos (lambda);
loop_nb = p__LOOP_MAX;
% in case longitude1 == longitude0, force one round
while ((loop_nb == p__LOOP_MAX) ...
            || (abs (lambda - prev_lambda) >= dlambda_min) && (loop_nb > 0))
    sin_sigma = sqrt ((cos_u1*sin_lambda)^2 ...
                             + (cos_u0*sin_u1 - sin_u0*cos_u1*cos_lambda)^2);
    cos_sigma = sin_u0*sin_u1 + cos_u0*cos_u1*cos_lambda;
    sigma     = atan2 (sin_sigma, cos_sigma); 
    if (sin_sigma == 0.0)
        % end point equal to, or diametrically opposite the start point
        sin_alpha = 0;
    else
        sin_alpha = cos_u0 * cos_u1 * sin_lambda / sin_sigma;
    end
    cos_alpha_sq = 1.0 - sin_alpha^2;
    if (cos_alpha_sq == 0.0)
        % start and end point are on the equator
        cos_2_sigma_m = 0.0;
    else
        cos_2_sigma_m = cos_sigma - 2.0*sin_u0*sin_u1/cos_alpha_sq;
    end
    c = f * cos_alpha_sq * (4.0 + f*(4.0 - 3.0*cos_alpha_sq)) / 16.0;
    tmp    = cos_sigma * (-1.0 + 2.0*cos_2_sigma_m^2);
    prev_lambda = lambda;
    lambda = dl + (1-c)*f*sin_alpha ...
                         *(sigma + c*sin_sigma*(cos_2_sigma_m + c*tmp));
    sin_lambda = sin (lambda);
    cos_lambda = cos (lambda);
    loop_nb = loop_nb - 1;
end
if (loop_nb == 0)
    warning ('inverse Vincenty does not converge after %d iterations, (%f)', ...
             p__LOOP_MAX, abs (lambda - prev_lambda));
end

u_sq   = cos_alpha_sq * (a^2 - b^2) / b^2;
% TODO test Vincenty's simplifications:
% dum = sqrt (1.0 + u_sq);
% k1 = (dum - 1.0) / (dum + 1.0);
% big_a = (1.0 + (k1^2) / 4.0) / (1.0 - k1);
% big_b = k1 * (1.0 - 3.0*(k1^2)/8.0);
big_a  = 1 + u_sq*(4096 + u_sq*(-768 + u_sq*(320 - 175*u_sq))) / 16384;
big_b  = u_sq*(256 + u_sq*(-128 + u_sq*(74 - 47*u_sq))) / 1024;
dsigma = big_b*sin_sigma ...
              *(cos_2_sigma_m ...
                     + big_b*(tmp-big_b*cos_2_sigma_m ...
                                       *(-3+4*sin_sigma^2)
                                       *(-3+4*cos_2_sigma_m^2)/6)/4);
% tada... the results:
distance = b * big_a * (sigma - dsigma);
azimuth  = atan2 (cos_u1 * sin_lambda, ...
                  cos_u0*sin_u1 - sin_u0*cos_u1*cos_lambda);
% reverse azimuth is given by:
% atan2 (cos_u0 * sin_lambda, -sin_u0*cos_u1 + cos_u0*sin_u1*cos_lambda);
if (azimuth < 0.0)
    azimuth = azimuth + pi;
end
if (longitude0 > longitude1)
    azimuth = azimuth + pi;
end
if (longitude0 == longitude1)
    azimuth = 0.0;
    if (latitude0 > latitude1)
        azimuth = pi;
    end
end

%!demo
%!
%! lat0 =  -37 - (57/60) -  (3.72030)/3600
%! lon0 = +144 + (25/60) + (29.52440)/3600
%! lat1 =  -37 - (39/60) - (10.15610)/3600
%! lon1 = +143 + (55/60) + (35.38390)/3600
%! % must give az = 306 + (52/60) + (5.37/3600) and dist = 54972.271
%! % see http://www.ga.gov.au/geodesy/datums/vincenty_inverse.jsp
%! [az, dist] = ivincenty (pi*lat0/180, pi*lon0/180, pi*lat1/180, pi*lon1/180);
%! dist
%! 180*az/pi
