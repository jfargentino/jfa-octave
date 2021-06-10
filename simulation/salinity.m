function S = salinity (T, P, R)

% Ratio between the in-situ conductivityt to the conductivity of the same
% at the same temperature but at p=0
e = [3.989e-12, -6.370e-8, 2.070e-4];
d = [4.464e-4, 3.426e-2, 1];
f = [-3.107e-3, 4.215e-1];
Rp = 1 + repmat (P .* polyval (e, P), size (T)) ./ (polyval (d, T) + polyval (f, T) * R)

% Ratio of the conductivity of reference seawater (PS 35), at temperature t,
% to its conductivity at t = 15°C
c = [1.0031e-9, -6.9698e-7, 1.104259e-4, 2.00564e-2, 0.6766097];
rt = polyval (c, T)

% Rt is the ratio of the conductivity of seawater, at temperature t, to the
% conductivity of seawater of PS 35, at the same temperature, both sample at
% a pressure of 1 standard atmosphere
Rt = R ./ (Rp .* rt);

% then we calculate the in-situ practical salinity
a = [2.7081, -7.0261, 14.0941, 25.3851, -0.1692, 0.0080];
b = [-0.0144, 0.0636, -0.0375, -0.0066, -0.0056, 0.0005];
k = 0.0162;
dS = polyval (b, sqrt (Rt)) .* (T - 15) ./ (1 + k * (T - 15));
S = polyval (a, sqrt (Rt)) + dS;
