function [alpha, c] = francoisGarrisonAbsorption (f, T, D, S, pH)

%
% function alpha = francoisGarrisonAbsorption (f, T, D [, S, pH])
%
% calculation of absorption according to:
% Francois & Garrison, J. Acoust. Soc. Am., Vol. 72, No. 6, December 1982
%
% f frequency (kHz)
% T Temperature (degC)
% D Depth (m)
% S Salinity (ppt) [35 by default]
% pH Acidity [8 by default]
%
% return alpha in dB/km
% return c in m/s
%
% Total absorption = Boric Acid Contribution
%                   + Magnesium Sulphate Contribution
%                   + Pure Water Contribution
%
% Francois and Garrison estimate their model to be accurate to within about 5%.
% For frequencies of 10-500 kHz (where the MgSO4 contribution dominates), the
% limits of reliability are:
%   -2 < T < 22 °C
%   30 < S < 35 ppt
%   0 < D < 3.5 km
%
% At frequencies greater than 500 kHz, the pure water contribution exceeds that
% of MgSO4, and the limits are:
%   0 < T < 30 °C
%   0 < S < 40 ppt
%   0 < D < 10 km 
%
% REFERENCES
% * Francois R. E., Garrison G. R.,
%   "Sound absorption based on ocean measurements, Part I:
%   Pure water and magnesium sulfate contributions",
%   Journal of the Acoustical Society of America, 72(3), 896-907, 1982.
% * Francois R. E., Garrison G. R.,
%   "Sound absorption based on ocean measurements, Part II:
%   Boric acid contribution and equation for total absorption",
%   Journal of the Acoustical Society of America, 72(6), 1879-1890, 1982.
%

if (nargin == 3)
    S  = 35;
    pH = 8;
end
if (nargin == 4)
    pH = 8;
end

ff  = f .* f;
fff = ff .* f;
    
kelvin = 273;
%kelvin = 273.15;
T_kel  = kelvin + T;

% Calculate speed of sound (according to Francois & Garrison, JASA 72 (6) p1886)
c = 1412 + 3.21*T + 1.19*S + 0.0167*D;

% Boric acid contribution,
% A1 in dB/km/kHz,
% P1 pressure correction factor
% f1 in kHz
A1 = (8.86 / c ) * 10^(0.78 * pH - 5);
P1 = 1;
f1 = 2.8 * sqrt(S / 35) * 10^(4 - 1245 / T_kel);
Boric = (A1 * P1 * f1 * ff) ./ (ff + f1*f1);

% MgSO4 contribution
% A2 in dB/km/kHz,
% P2 pressure correction factor
% f2 in kHz
A2 = 21.44 * (S / c) * (1 + 0.025 * T);
P2 = 1 - 1.37e-4*D + 6.2e-9*D*D;
f2 = (8.17 * 10^(8 - 1990/T_kel))/(1 + 0.0018 * (S - 35));
MgSO4 = (A2 * P2 * f2*ff) ./ (ff + f2*f2);

% Pure water contribution
% A3 in dB/km/kHz,
% P3 pressure correction factor
if (T <= 20)
	A3 = 4.937e-4 - 2.59e-5*T + 9.11e-7*T*T - 1.5e-8*T*T*T;
else
	A3 = 3.964e-4 - 1.146e-5*T + 1.45e-7*T*T - 6.5e-10*T*T*T;
end
P3 = 1 - 3.83e-5*D + 4.9e-10*D*D;
H2O = A3*P3*ff;

% Total absorption
alpha = Boric + MgSO4 + H2O;
