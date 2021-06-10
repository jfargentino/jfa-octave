function eta_Pa_s = viscosity_iapws08 (t_its90, s_psu)
%
% function eta_Pa_s = viscosity_iapws08 (t_ipts68, s_psu)
%
% Return the dynamic viscosity of seawater for given temperature and salinity
% The viscosity is in Pa.s (1Pa.s= 1kg/m.s = 10P Poise).
%
% TODO: Where does the salinity polynomial come from?
%
% Ref: "Thermophysical Properties of Seawater: a Review of Existing
% Correlations and Data", equation 22
%

[r0, c0] = size(s_psu);
[r1, c1] = size(t_its90);
if ((r0~=r1) || (c0~=c1))
    t_its90 = t_its90(:);
    row = length (t_its90);
    s_psu = s_psu(:)'/1000; % Formula is given with salinity in kg/kg
    col = length (s_psu);
    t_its90 = repmat (t_its90, 1, col);
    s_psu   = repmat (s_psu, row, 1);
end

a = 1.5409136040 + 1.9981117208E-02*t_its90 - 9.5203865864E-05*t_its90.^2;
b = 7.9739318223 - 7.5614568881E-02*t_its90 + 4.7237011074E-04*t_its90.^2;
eta_Pa_s = pure_water_viscosity_iapws08(t_its90) ...
                    .* (1 + a .* s_psu + b .* s_psu.^2);

%!demo
%!
%! % PSU         0      5     10     15     20     25     30     35
%! eta_ref = [ 1.791, 1.804, 1.817, 1.831, 1.844, 1.857, 1.870, 1.884; ... % 0°C
%!             1.519, 1.531, 1.543, 1.555, 1.567, 1.579, 1.592, 1.604; ... % 5°C
%!             1.307, 1.318, 1.329, 1.341, 1.352, 1.363, 1.374, 1.385; ... %10°C
%!             1.138, 1.149, 1.160, 1.170, 1.180, 1.190, 1.201, 1.211; ... %15°C
%!             1.002, 1.012, 1.022, 1.032, 1.041, 1.051, 1.061, 1.070; ... %20°C
%!             0.890, 0.900, 0.909, 0.918, 0.927, 0.936, 0.946, 0.955; ... %25°C
%!             0.797, 0.807, 0.816, 0.824, 0.833, 0.841, 0.850, 0.858; ... %30°C
%!             0.719, 0.729, 0.737, 0.745, 0.753, 0.761, 0.769, 0.777 ];   %35°C
%! eta = viscosity_iapws08 ((0:5:35)/1.00024, 0:5:35);
%! imagesc (0:5:35, 0:5:35, eta - eta_ref/1000);
%! colorbar;
%! xlabel ('salinity (P.S.U.)');
%! ylabel ('temperature (Celsius degrees)');
%! grid on

%!demo
%!
%! t_its90 = 0:40;
%! s_psu   = 0:40;
%! eta = viscosity_iapws08 (t_its90, s_psu);
%! imagesc (s_psu, t_its90, 1000*eta);
%! colorbar;
%! xlabel ('salinity (P.S.U.)');
%! ylabel ('temperature (Celsius degrees ITS90)');
%! title ('Viscosity in mPa.s');
%! grid on;
