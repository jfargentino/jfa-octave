function R = acoustic_roughness (h, f, c, theta)

k = 2 * pi * f / c;
R = 2 * k * h * cos (theta);

%!demo
%! h     = 0.01;
%! f     = 10e3;
%! c     = 1500;
%! theta = -pi/2 : 0.001 : +pi/2;
%! R     = acoustic_roughness (h, f, c, theta);
%! figure (1);
%! grid on;
%! title ('Rugosite acoustique')
%! xlabel ('angle incidence en degres')
%! ylabel ('Coefficient de Rayleigh')
%! plot (theta * 180 / pi, R)
%! figure (2);
%! grid on;
%! title ('Coefficient de reflexion')
%! xlabel ('angle incidence en degres')
%! plot (theta * 180 / pi, exp (-R .* R))
