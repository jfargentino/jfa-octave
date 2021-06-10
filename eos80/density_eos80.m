function [d_kg_m3, k, k_p0, a, b] = density_eos80 (s_psu, t_ipts68, p_bar)
%
% function [d_kg_m3, k, k_p0, a, b] = density_eos80 (s_psu, t_ipts68, p_bar)
%
% International equation of state of seawater EOS80
% Ref. UNESCO Technical Papers in Marine Science nb 36 (1980)
%      Millero and Poisson
%
% Inputs:
%    - s_psu salinity in practical salinity unit, from 0 to 42 P.S.U.
%    - t_ipts68 temperature in Celsius degrees in IPTS68, from -2 to 40 degrees
%    - p_bar relative pressure, from 0 to 1000 bars (1 bar = 1e5 Pa)
% Or:
%    - [p, t, s] to get density for each line triplet.
%
% If ITS90 temperature is used, we have t(IPTS68) = 1.00024 x t(ITS90)
%
% Outputs:
%    - d_kg_m3 density in kg/m^3 (given precision is 3.5 ppm)
%    - k secant bulk modulus (in pascal) = k_p0 + a.*p_bar + b.*p_bar^2,
%      row for salinity, column for temperature.
%

if (nargin == 1)
    [r, c] = size (s_psu);
    if (c == 3)
        % TODO anything else than a loop ???
        d_kg_m3 = zeros (r, 1);
        k       = d_kg_m3;
        for n = 1:r
            [d_kg_m3(n), k(n)] = density_eos80 (s_psu(n, 1), ...
                                                s_psu(n, 2), ...
                                                s_psu(n, 3));
        end
        return
    end
end
if (nargin < 3)
  p_bar = 0.0;
end
if (nargin < 2)
  t_ipts68 = 15.0;
end
if (nargin < 1)
  s_psu = 35.0;
end

[r0, c0] = size(s_psu);
[r1, c1] = size(t_ipts68);
[r2, c2] = size(p_bar);

if ((r0~=r1) || (r0~=r2) || (r1~=r2) || (c0~=c1) || (c0~=c2) || (c1~=c2))

    t_ipts68 = t_ipts68(:)';
    col = length (t_ipts68);
    p_bar = p_bar(:);
    row = length (p_bar);
    s_psu = s_psu(:);
    dep = length (s_psu);

    % TODO
    %s_psu = reshape (s_psu, 1, 1, dep);
    %t_ipts68 = repmat (t_ipts68, row, 1,   dep);
    %p_bar    = repmat (p_bar,    1  , col, dep);
    %s_psu    = repmat (s_psu,    row, col, 1);
    if ((row == 1) && (dep > 1))
        t_ipts68 = repmat (t_ipts68, dep, 1);
        s_psu    = repmat (s_psu,    1  , col);
    else
        t_ipts68 = repmat (t_ipts68, row, 1);
        p_bar    = repmat (p_bar,    1  , col);
    end

end

% rho_w is density of pure water, depending on temperature only %%%%%%%%%%%%%%%%
rho_w = 999.842594 ...
           + 6.793952e-2 * t_ipts68 ...
           - 9.095290e-3 * (t_ipts68.*t_ipts68) ...
           + 1.001685e-4 * (t_ipts68.*t_ipts68.*t_ipts68) ...
           - 1.120083e-6 * (t_ipts68.*t_ipts68.*t_ipts68.*t_ipts68) ...
           + 6.536332e-9 * (t_ipts68.*t_ipts68.*t_ipts68.*t_ipts68.*t_ipts68);

% rho_p0 is density at one standard atmosphere (p = 0) %%%%%%%%%%%%%%%%%%%%%%%%%
tmp1 = 0.824493 ...
        - 4.0899e-3 * t_ipts68 ...
        + 7.6438e-5 * (t_ipts68.*t_ipts68) ...
        - 8.2467e-7 * (t_ipts68.*t_ipts68.*t_ipts68) ...
        + 5.3875e-9 * (t_ipts68.*t_ipts68.*t_ipts68.*t_ipts68);
tmp3_2 = -5.72466e-3 ...
           + 1.0227e-4 * t_ipts68 ...
           - 1.6546e-6 * (t_ipts68.*t_ipts68);
rho_p0 = rho_w ...
            + tmp1 .* s_psu ...
            + tmp3_2 .* power (s_psu, 3/2)...
            + 4.8314e-4 .* s_psu .* s_psu;

% k_w is the secant bulk modulus of pure water, depending on temperature only %%
k_w = 19652.21 ...
           + 148.4206    * t_ipts68 ...
           - 2.327105    * (t_ipts68.*t_ipts68) ...
           + 1.360477e-2 * (t_ipts68.*t_ipts68.*t_ipts68) ...
           - 5.155288e-5 * (t_ipts68.*t_ipts68.*t_ipts68.*t_ipts68);

% k_p0 is the secant bulk modulus at one standard atmosphere (p = 0) %%%%%%%%%%%
tmp1 = 54.6746 ...
         - 0.603459   * t_ipts68 ...
         + 1.09987e-2 * (t_ipts68.*t_ipts68) ...
         - 6.1670e-5  * (t_ipts68.*t_ipts68.*t_ipts68);
tmp3_2 = 7.944e-2 ...
          + 1.6483e-2 * t_ipts68 ...
          - 5.3009e-4 * (t_ipts68.*t_ipts68);
k_p0 = k_w + tmp1 .* s_psu + tmp3_2 .* power (s_psu, 3/2);

% k is the secant bulk modulus %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tmp_p = 3.239908 ...
         + 1.43713e-3 * t_ipts68 ...
         + 1.16092e-4 * (t_ipts68.*t_ipts68) ...
         - 5.77905e-7 * (t_ipts68.*t_ipts68.*t_ipts68);
tmp_ps = 2.2838e-3 ...
          - 1.0981e-5 * t_ipts68 ...
          - 1.6078e-6 * (t_ipts68.*t_ipts68);
tmp_p2 = 8.50935e-5 ...
          - 6.12293e-6 * t_ipts68 ...
          + 5.2787e-8  * (t_ipts68.*t_ipts68);
tmp_p2s = -9.9348e-7 ...
            + 2.0816e-8  * t_ipts68 ...
            + 9.1697e-10 * (t_ipts68.*t_ipts68);
%a = tmp_p + tmp_ps .
%k = k_p0 ...
%     + tmp_p     .* p_bar ...
%     + tmp_ps    .* p_bar .* s_psu ...
%     + 1.91075e-4 * p_bar .* power (s_psu, 3/2) ...
%     + tmp_p2    .* (p_bar .* p_bar) ...
%     + tmp_p2s   .* (p_bar .* p_bar) .* s_psu;
a = tmp_p  + tmp_ps .*s_psu + 1.91075e-4*power(s_psu, 3/2);
b = tmp_p2 + tmp_p2s.*s_psu;
k = k_p0 + a.*p_bar + b.*p_bar.*p_bar;

% And the result is ... %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
d_kg_m3 = rho_p0 ./ (1.0 - p_bar./k);

%!demo
%! %Check results against "UNESCO Technical Papers in Marine Science 36, The
%! %Practical Salinity Scale 1978 and the Internation Equation of State of
%! %Seawater 1980", page 19
%!
%! s_psu = 0, t_ipts68 = 5, p_bar = 0
%! d_kg_m3 = 999.96675, k_pascal = 20337.80375
%! [d, k] = density_eos80 (s_psu, t_ipts68, p_bar);
%! [d, k] - [d_kg_m3, k_pascal]
%!
%! s_psu = 0, t_ipts68 = 5, p_bar = 1000,
%! d_kg_m3 = 1044.12802, k_pascal = 23643.52599
%! [d, k] = density_eos80 (s_psu, t_ipts68, p_bar);
%! [d, k] - [d_kg_m3, k_pascal]
%!
%! s_psu = 0, t_ipts68 = 25, p_bar = 0,
%! d_kg_m3 = 997.04796, k_pascal = 22100.72106
%! [d, k] = density_eos80 (s_psu, t_ipts68, p_bar);
%! [d, k] - [d_kg_m3, k_pascal]
%!
%! s_psu = 0, t_ipts68 = 25, p_bar = 1000,
%! d_kg_m3 = 1037.90204, k_pascal = 25405.09717
%! [d, k] = density_eos80 (s_psu, t_ipts68, p_bar);
%! [d, k] - [d_kg_m3, k_pascal]
%!
%! s_psu = 35, t_ipts68 = 5, p_bar = 0,
%! d_kg_m3 = 1027.67547, k_pascal = 22185.93358
%! [d, k] = density_eos80 (s_psu, t_ipts68, p_bar);
%! [d, k] - [d_kg_m3, k_pascal]
%!
%! s_psu = 35, t_ipts68 = 5, p_bar = 1000,
%! d_kg_m3 = 1069.48914, k_pascal = 25577.49819
%! [d, k] = density_eos80 (s_psu, t_ipts68, p_bar);
%! [d, k] - [d_kg_m3, k_pascal]
%!
%! s_psu = 35, t_ipts68 = 25, p_bar = 0,
%! d_kg_m3 = 1023.34306, k_pascal = 23726.34949
%! [d, k] = density_eos80 (s_psu, t_ipts68, p_bar);
%! [d, k] - [d_kg_m3, k_pascal]
%!
%! s_psu = 35, t_ipts68 = 25, p_bar = 1000,
%! d_kg_m3 = 1062.53817, k_pascal = 27108.94504
%! [d, k] = density_eos80 (s_psu, t_ipts68, p_bar);
%! [d, k] - [d_kg_m3, k_pascal]
%!

%!demo
%! % Show that once salinity and temperature set, the density is near a linear
%! % function of the pressure.
%! s_psu    = (20:42)';
%! t_ipts68 = (-2:15)';
%! p_bar    = (0:300)';
%! Np       = length(p_bar);
%! d = zeros (length(s_psu), length(t_ipts68), Np);
%! for n = 1:Np
%!     d(:, :, Np - n + 1) = density_eos80 (s_psu, t_ipts68, p_bar(n));
%! end
%! figure
%! imagesc (t_ipts68, s_psu, d(:, :, end) - d(:, :, 1));
%! colorbar
%! xlabel ('temperature in Celsius degrees (IPTS68)');
%! ylabel ('salinity in P.S.U.');
%! grid on;
%! title(sprintf('density difference between %.0f bar and %.0f bar, in kg/m^3',
%!               p_bar(end), p_bar(1)));
%!
%! dd = diff (d, 1, 3);
%! figure
%! plot (p_bar(2:end), reshape(dd(1, 1, :), 1, Np-1), ...
%!       p_bar(2:end), reshape(dd(1, end, :), 1, Np-1), ...
%!       p_bar(2:end), reshape(dd(end, 1, :), 1, Np-1), ...
%!       p_bar(2:end), reshape(dd(end, end, :), 1, Np-1));
%! grid on
%! xlabel ('pressure in bar');
%! ylabel ('density/pressure rate');
%! legend (sprintf('%.0f PSU and %0.f deg C', s_psu(1), t_ipts68(1)), ...
%!         sprintf('%.0f PSU and %0.f deg C', s_psu(1), t_ipts68(end)), ...
%!         sprintf('%.0f PSU and %0.f deg C', s_psu(end), t_ipts68(1)), ...
%!         sprintf('%.0f PSU and %0.f deg C', s_psu(end), t_ipts68(end)));
%!

%!demo
%! t_ipts68 = -2:0.1:40;
%! s_psu = 0:0.1:40;
%! [d, k, k_p0, a, b] = density_eos80 (s_psu, t_ipts68, 0);
%! 
%! figure
%! imagesc (t_ipts68, s_psu, k_p0);
%! colorbar;
%! grid on;
%! xlabel ('temperature in Celsius degrees (IPTS68)');
%! ylabel ('salinity in P.S.U.');
%! title (sprintf('secant bulk modulus at atmospheric pressure'));
%! 
%! figure
%! imagesc (t_ipts68, s_psu, a);
%! colorbar;
%! grid on;
%! xlabel ('temperature in Celsius degrees (IPTS68)');
%! ylabel ('salinity in P.S.U.');
%! title (sprintf('secant bulk modulus 1st order coeff'));
%! 
%! figure
%! imagesc (t_ipts68, s_psu, b);
%! colorbar;
%! grid on;
%! xlabel ('temperature in Celsius degrees (IPTS68)');
%! ylabel ('salinity in P.S.U.');
%! title (sprintf('secant bulk modulus 2nd order coeff'));

%!demo
%! s_psu = 35.0;
%! t_ipts68 = -2:40;
%! p_bar = 0:250;
%! d = density_eos80 (s_psu, t_ipts68, p_bar);
%! imagesc (t_ipts68, p_bar, d);
%! colorbar;
%! grid on;
%! xlabel ('temperature in Celsius degrees (IPTS68)');
%! ylabel ('pressure in bar');
%! title (sprintf('seawater density in kg/m^3 for %.3f P.S.U', s_psu));

%!demo
%! t_ipts68 = -2:40;
%! p_bar = 0:250;
%! d30 = density_eos80 (30, t_ipts68, p_bar);
%! d40 = density_eos80 (40, t_ipts68, p_bar);
%! imagesc (t_ipts68, p_bar, d40 - d30);
%! colorbar;
%! grid on;
%! xlabel ('temperature in Celsius degrees (IPTS68)');
%! ylabel ('pressure in bar');
%! title (sprintf ('density difference between 30 and 40 P.S.U.'))

%!demo
%! t_ipts68 = -2:40;
%! s_psu = 30:40;
%! d0 = zeros (length(t_ipts68), length(s_psu));
%! d250 = d0;
%! for n=1:length(s_psu)
%!     d0(:, n)    = density_eos80 (s_psu(n), t_ipts68, 0);
%!     d250(:, n)  = density_eos80 (s_psu(n), t_ipts68, 250);
%! end
%! imagesc (t_ipts68, s_psu, d250 - d0);
%! colorbar;
%! grid on;
%! xlabel ('temperature in Celsius degrees (IPTS68)');
%! ylabel ('salinity in P.S.U.');
%! title (sprintf ('density difference between 0 and 250 bar'))

%!demo
%!t_ipts68 = -2:0.01:40;
%!s_psu = 30:40;
%!dd0   = zeros (length(t_ipts68), length(s_psu));
%!dd50  = dd0;
%!dd100 = dd0;
%!dd150 = dd0;
%!dd200 = dd0;
%!dd250 = dd0;
%!for n=1:length(s_psu)
%!    dd0(:, n)   = density_eos80 (s_psu(n), t_ipts68, 0);
%!    dd50(:, n)  = density_eos80 (s_psu(n), t_ipts68, 50);
%!    dd150(:, n) = density_eos80 (s_psu(n), t_ipts68, 100);
%!    dd150(:, n) = density_eos80 (s_psu(n), t_ipts68, 150);
%!    dd200(:, n) = density_eos80 (s_psu(n), t_ipts68, 200);
%!    dd250(:, n) = density_eos80 (s_psu(n), t_ipts68, 250);
%!end
%!ddx = d0;
%!p_bar = 0;
%!imagesc (t_ipts68, s_psu, ddx);
%!colorbar;
%!grid on;
%!xlabel ('temperature in Celsius degrees (IPTS68)');
%!ylabel ('salinity in P.S.U.');
%!title (sprintf ('d density / difference between 0 and 250 bar'))

