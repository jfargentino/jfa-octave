function alpha = ainslieMcColmAbsorption (f, T, S, D, pH)
%
% function alpha = ainslieMcColmAbsorption (f, T, S, D, pH)
%
% calculation of absorption according to:
% Ainslie & McColm, J. Acoust. Soc. Am., Vol. 103, No. 3, March 1998
%
% f frequency (kHz)
% T Temperature (degC)
% S Salinity (ppt)
% D Depth (m)
% pH Acidity
%
% return alpha in dB/km
%
% Total absorption = Boric Acid Contrib.
%                    + Magnesium Sulphate Contrib.
%                    + Pure Water Contrib.
%
% The Ainslie and McColm formula retains accuracy to within 10% of the Francois
% and Garrison model between 100 Hz and 1 MHz for the following range of
% oceanographic conditions:
%   -6 < T < 35 °C 	(S = 35 ppt, pH=8, D = 0 km)
%   7.7 < pH < 8.3 	(T = 10 °C, S = 35 ppt, D = 0 km)
%   5 < S < 50 ppt 	(T = 10 °C, pH = 8, D = 0 km)
%   0 < D < 7 km 	(T = 10 °C, S = 35 ppt, pH = 8)
%
% REFERENCE
% Ainslie M. A., McColm J. G.,
% "A simplified formula for viscous and chemical absorption in sea water"
% Journal of the Acoustical Society of America, 103(3), 1671-1672, 1998.
%

Kelvin = 273.1;
T_kel = Kelvin + T;

% Boric acid contribution
A1 = 0.106 * exp((pH - 8)/0.56);
P1 = 1;
f1 = 0.78 * sqrt(S / 35) * exp(T/26);
Boric = (A1 * P1 * f1*f*f)/(f*f + f1*f1);

% MgSO4 contribution
A2 = 0.52 * (S / 35) * (1 + T/43);
P2 = exp(-D/6000);
f2 = 42 * exp(T/17);
MgSO4 = (A2 * P2 * f2*f*f)/(f*f + f2*f2);

% Pure water contribution
A3 = 0.00049*exp(-(T/27 + D/17000));
P3 = 1;
H2O = A3 * P3 * f*f;

% Total absorption (dB/km)
alpha = Boric + MgSO4 + H2O;
