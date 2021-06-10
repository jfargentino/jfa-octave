function eta_Pa_s = pure_water_viscosity_iapws08 (t_its90)
%
% function eta_Pa_s = pure_water_viscosity_iapws08 (t_its90)
%
% Get the viscosity of pure water depending on the temperature, in Celsius
% degrees, ITS90. The returned viscosity is in Pa.s (1Pa.s= 1kg/m.s = 10P).
%
% TODO I'm using the polynomial found in "Thermophysical Properties of
% Seawater: a Review of Existing Correlations and Data", equation 23, but it
% does not look like what is found in "International Association for the
% Properties of Water and Steam, release on the IAPWS formulation 2008 for the
% viscosity of ordinary water substance", 2008
%

eta_Pa_s = 4.2844324477E-05 ...
               + 1 ./ (1.5700386464E-01*(t_its90 + 6.4992620050E+01).^2 ...
                                       - 9.1296496657E+01);

%Tref = 647.096;
%RHOref = 322.0;
%ETAref = 1e-6;
%
%t = (t_its90 + 273.15) / Tref;
%eta0 = 100 * sqrt (t) ...
%          ./ (1.67752 + 2.20462./t + 0.6366564./(t.^2) - 0.241605./(t.^3));
%eta = eta0 * ETAref;
