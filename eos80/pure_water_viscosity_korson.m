function eta_Pa_s = pure_water_viscosity_korson (t_ipts68)
%
% function eta_Pa_s = pure_water_viscosity_korson (t_ipts68)
%
% Get the viscosity of pure water depending on the temperature, in Celsius
% degrees, IPTS68. The returned viscosity is in Pa.s (1Pa.s= 1kg/m.s = 10P).
%
% Ref: "Viscosity of Water at Various Temperatures", Korson Drost-Hansen and 
%      Millero in J. Phys. Chem 73(1), 1969
%
% TODO "Properties of ordinary water-substance in all its phases", Dorsey, 1940
% TODO "Viscosity of liquid water from 25°C to 150°C", Korosi and Fabuss, 1968
%

eta20 = 1.002e-3; % Viscosity of distilled water at 20°C (Swindells et al.)

tmp = (1.1709*(20 - t_ipts68) - 1.827e-3*(20 - t_ipts68).*(20 - t_ipts68)) ...
                              ./ (t_ipts68 + 89.93);
eta_Pa_s = eta20 * power (10.0, tmp);
