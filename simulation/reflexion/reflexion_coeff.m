function a = reflexion_coeff (c1, m1, c2, m2, alpha)
%
% function a = reflexion_coeff (c1, m1, c2, m2, alpha)
%
%    Calcul du coefficient de reflexion depuis le milieu 1 caracterise
% par c1 vitesse du son et m1 sa masse volumique, vers le milieu 2 de
% masse volumique m2 et de celerite c2, sous l'angle d'incidence alpha
% (0 par defaut). L'interface entre les deux milieux est consideree
% comme parfaitement lisse.
%
%
%        \  |a /
%         \ |^/ (C1, M1) 
%    ______\|/________
%
%               (C2, M2)
%
%

if (nargin < 5)
   alpha = 0;
end

% Loi de Snell-Descartes
% Alpha est l'angle d'incidence
alpha1 = alpha;
tmp    = sin (alpha1) * c2 / c1;
% Au dela de l'angle critique, reflexion totale
tmp (find (tmp > +1)) = +1;
alpha2 = asin (tmp);
% Calcul du coeff de reflexion
z1     = c1 * m1;
z2     = c2 * m2;
tmp1   = z2 * cos (alpha1);
tmp2   = z1 * cos (alpha2);
a      = sign (z2 - z1) * abs ((tmp1 - tmp2) ./ (tmp1 + tmp2));

%!demo
%! c_air = 340;
%! m_air = 1.3;
%! c_eau = 1500;
%! m_eau = 1000;
%! alpha = [-pi/2 : 0.001 : +pi/2];
%! a = reflexion_coeff (c_eau, m_eau, c_air, m_air, alpha);
%! grid on,
%! title ('Coefficient de reflexion, interface eau-air');
%! xlabel ('angle incidence en degres');
%! ylabel ('Coefficient de reflexion');
%! plot (alpha * 180 / pi, a)
