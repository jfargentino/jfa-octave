function [r, dt, a, theta, impact] = reflected (pinger, plane, hydro, T, S, Cout, Mout)
%
% function [r, dt, a, theta, impact] = reflected (pinger, plane, hydro, T, S, Cout, Mout)
%
%

% virtual is the symmetrical of hydro per plane
virtual = symmetrical (plane, hydro);
% impact is the intersection between plane and the line (pinger, virtual)
impact  = intersection (plane, pinger, virtual);

% Path length between pinger and impact
r0 = range (pinger, impact);
% Mean celerity between pinger and impact
c0 = celerity (T, (pinger(3) + impact(3))/20, S);
% Path length between impact and hydro
r1 = range (impact, hydro);
% Mean celerity between impact and hydro
c1 = celerity (T, (impact(3) + hydro(3))/20, S);
% Delay due to path length
dt = r0 / c0 + r1 / c1;
% Path length
r = r0 + r1;

% path support vector
u = impact - pinger;

% Incidence angle
pinger_proj = projected (plane, pinger);
theta = asin (range (pinger_proj, impact) / r0);

% reflection coefficient
a = reflexion_coeff (celerity (T, impact(3), S), density (T, impact(3), S), ...
                     Cout, Mout, theta);

