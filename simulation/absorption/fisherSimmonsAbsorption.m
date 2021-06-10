function alpha = fisherSimmonsAbsorption (f, T, D)
%
% function alpha = fisherSimmonsAbsorption (f, T, D)
%
% calculation of absorption according to:
% Fisher & Simmons, J. Acoust. Soc. Am., Vol. 62, No. 3, September 1977
%
% f frequency (kHz)
% T Temperature (degC)
% D Depth (m)
%
% return alpha in dB/km
%
% Total absorption = Boric Acid Contrib.
%                     + Magnesium Sulphate Contrib.
%                     + Pure Water Contrib.
%
% When using water other than the Lyman and Fleming standard (S = 35, pH = 8),
% the Fisher & Simmons algorithm is invalid.
%
% REFERENCE
% Fisher F. H., Simmons V. P.,
% "Sound absorption in seawater",
% Journal of the Acoustical Society of America, 62, 558-564, 1977.
%

Kelvin = 273.1;
T_kel = Kelvin + T;

% Convert Depth back to pressure (assuming P = D/10)
P = D / 10.0;

% Convert f into Hz
f = f * 1000;

% Boric acid contribution
A1 = 1.03e-8 + 2.36e-10*T - 5.22e-12*T*T;
P1 = 1;
f1 = 1.32e3 * T_kel * exp(-1700 / T_kel);
Boric = (A1 * P1 * f1*f*f)/(f*f + f1*f1);

% MgSO4 contribution
A2 = 5.62e-8 + 7.52e-10*T;
P2 = 1 - 10.3e-4*P + 3.7e-7*P*P;
f2 = 1.55e7 * T_kel * exp(-3052 / T_kel);
MgSO4 = (A2 * P2 * f2*f*f)/(f*f + f2*f2);

% Pure water contribution
A3 = (55.9 - 2.37*T + 4.77e-2*T*T - 3.48e-4*T*T*T ) * 1e-15;
P3 = 1 - 3.84e-4*P + 7.57e-8*P*P;
H2O = A3 * P3 * f*f;

% Total absorption (dB/km) (8686 converts to dB/km)
alpha = (Boric + MgSO4 + H2O) * 8686;
