function eta_Pa_s = viscosity_millero (t_ipts68, s_psu, p_bar)
%
% function eta_Pa_s = viscosity_millero (t_ipts68, s_psu, p_bar)
%
% Return the dynamic viscosity of seawater for given temperature, salinity and
% pressure. The viscosity is in Pa.s (1Pa.s= 1kg/m.s = 10P Poise).
% TODO: not so sure for pressure > 0 bar
% Ref: "The Sea, Vol. 5, 3-80", Millero, 1974
%

if (nargin < 3)
    p_bar = 0;
end

t_ipts68 = t_ipts68(:);
row = length (t_ipts68);
s_psu = s_psu(:)';
rho = zeros (length (t_ipts68), length (s_psu));
% TODO Once density_eos80 handle s_psu matrix, no more loop
for n = 1:length (s_psu)
    rho(:, n) = density_eos80 (s_psu(n), t_ipts68, p_bar)';
end
col = length (s_psu);
t_ipts68 = repmat (t_ipts68, 1, col);
s_psu   = repmat (s_psu, row, 1);

a = 1.0675e-4 + 5.185e-5 * t_ipts68;
b = 2.591e-3  + 3.300e-5 * t_ipts68;
vCl = rho .* s_psu / 1806.55;
eta_Pa_s = pure_water_viscosity_korson(t_ipts68).*(1 + a.*sqrt(vCl) + b.*vCl);

% TODO if S = 1.80655 * Cl, using 
% eta_p = -1.7913e-4*p + 9.5182e-8*p^2 ...
%           + p*(1.3550e-5*t - 2.5853e-7*t^2) ...
%           - p*p*(6.0833e-9*t - 1.1652e-10*t^2)

%!demo
%! % check the formula implementation against reference values
%! % PSU         0      5     10     15     20     25     30     35
%! eta_ref = [ 1.791, 1.804, 1.817, 1.831, 1.844, 1.857, 1.870, 1.884; ... % 0°C
%!             1.519, 1.531, 1.543, 1.555, 1.567, 1.579, 1.592, 1.604; ... % 5°C
%!             1.307, 1.318, 1.329, 1.341, 1.352, 1.363, 1.374, 1.385; ... %10°C
%!             1.138, 1.149, 1.160, 1.170, 1.180, 1.190, 1.201, 1.211; ... %15°C
%!             1.002, 1.012, 1.022, 1.032, 1.041, 1.051, 1.061, 1.070; ... %20°C
%!             0.890, 0.900, 0.909, 0.918, 0.927, 0.936, 0.946, 0.955; ... %25°C
%!             0.797, 0.807, 0.816, 0.824, 0.833, 0.841, 0.850, 0.858; ... %30°C
%!             0.719, 0.729, 0.737, 0.745, 0.753, 0.761, 0.769, 0.777 ];   %35°C
%! eta_mil = viscosity_millero (0:5:35, 0:5:35);
%! imagesc (0:5:35, 0:5:35, eta_mil - eta_ref/1000);
%! colorbar;
%! xlabel ('salinity (P.S.U.)');
%! ylabel ('temperature (Celsius degrees)');
%! grid on

%!demo
%! t_ipts68 = 0:40;
%! s_psu    = 0:40;
%! p_bar    = 100;
%! eta_mil = viscosity_millero (t_ipts68, s_psu, p_bar);
%! imagesc (s_psu, t_ipts68, 1000*eta_mil);
%! colorbar;
%! xlabel ('salinity (P.S.U.)');
%! ylabel ('temperature (Celsius degrees IPTS68)');
%! str = sprintf ('Viscosity in mPa.s for P=%.1fbar', p_bar);
%! title (str);
%! grid on;

%!demo
%! % show that viscosity does not change that much in regard to the pressure
%! t_ipts68 = 0:40;
%! s_psu    = 0:40;
%! eta0   = viscosity_millero (t_ipts68, s_psu, 0);
%! eta250 = viscosity_millero (t_ipts68, s_psu, 250);
%! imagesc (s_psu, t_ipts68, 1000*(eta250 - eta0));
%! colorbar;
%! xlabel ('salinity (P.S.U.)');
%! ylabel ('temperature (Celsius degrees IPTS68)');
%! str = sprintf ('Viscosity diff in mPa.s for %.1fbar and %.1fbar', 0, 250);
%! title (str);
%! grid on;

%!demo
%! % show that viscosity does not change that much in regard to the salinity
%! t_ipts68 = 0:40;
%! eta0  = viscosity_millero (t_ipts68, 0);
%! eta40 = viscosity_millero (t_ipts68, 40);
%! plot (t_ipts68, 1000*(eta40 - eta0));
%! xlabel ('temperature (Celsius degrees IPTS68)');
%! str = sprintf ('Viscosity diff in mPa.s for P.S.U. %.1f and %.1f', 0, 40);
%! title (str);
%! grid on;
