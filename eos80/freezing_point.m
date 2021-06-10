function t_ice = freezing_point (salinity_PSU, pressure_dbar)
%
% function t_ice = freezing_point (salinity_PSU, pressure_dbar)
%
% Seawater freezing point in °C as stated by UNESCO report 28 (1978).
% 
% Inputs:
%    - salinity_PSU salinity in P.S.U. (TODO validity range)
%    - pressure_dbar pressure in decibar (TODO validity range)
%
% Output:
%    - t_ice seawater freezing point in °C (TODO IPTS68 or ITS90)
%

A0 = -0.0575;
A1 = +1.710523e-3;
A2 = -2.154996e-4;
B0 = -7.53e-4;

if (nargin < 2)
    pressure_dbar = 0.0;
end
if (nargin < 1)
    salinity_PSU = 35.0;
end

[r0, c0] = size(salinity_PSU);
[r1, c1] = size(pressure_dbar);
if ((r0~=r1) || (c0~=c1))
    salinity_PSU  = salinity_PSU(:);
    pressure_dbar = pressure_dbar(:)';
    row = length (salinity_PSU);
    col = length (pressure_dbar);
    if (row ~= col)
        salinity_PSU  = repmat (salinity_PSU,  1, col);
        pressure_dbar = repmat (pressure_dbar, row, 1);
    end
end

t_ice = A0*salinity_PSU ...
            + A1*power(salinity_PSU, 3/2) ...
            + A2*salinity_PSU.*salinity_PSU ...
            + B0*pressure_dbar;

%!demo
%! %Checking
%! s_psu = 40.0; p_dbar = 500.0; t_ref = -2.588567;
%! t_ice = freezing_point (s_psu, p_dbar),
%! t_ice - t_ref

%!demo
%! s_psu = 0.0:0.1:42.0; p_dbar = 0.0:1.0:6000.0;
%! t_ice = freezing_point (s_psu, p_dbar);
%! imagesc (p_dbar, s_psu, t_ice);
%! grid on;
%! colorbar;
%! xlabel ('pressure in dbar');
%! ylabel ('salinity in P.S.U.');
%! title ('seawater freezing point in degrees Celsius');


