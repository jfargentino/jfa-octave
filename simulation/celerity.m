function [Cel, T, P] = celerity( T, P, S )
%
%function Cel = celerity( T, P, S )
%
%   Programme de calcul de la celerite du son dans l'eau de mer en metres par 
% seconde d'apres la formule de CHEN et MILLERO.
%   'T' tableau des temperatures en degres celsius (de 0 a 40°),
%   'P' tableau des pressions relatives par rapport a la surface en bar (de 0 a
%       1000 bars),
%   'S' la salinite en g.l-1 (de 0 a 40 PSU).
%
% TODO Bilaniuk Wong 112 for celerity in pure water
%
         
Tmin = 0;         
T0   = 14;%14 Degres Celsius
Tmax = 40;
Pmin = 0;%surface
Pmax = 1000;
Smin = 0;%eau douce
Smax = 40;

switch( nargin )
   case 0,
   T = T0;
   P = Pmin;
   S = Smin;
   
   case 1;
   T = min( Tmax, max( T, Tmin ) ); 
   P = Pmin;
   S = Smin;
   
   case 2,
   T = min( Tmax, max( T, Tmin ) ); 
   P = min( Pmax, max( P, Pmin ) );
   S = Smin;

   case 3,
   T = min( Tmax, max( T, Tmin ) ); 
   P = min( Pmax, max( P, Pmin ) );
   S = min( Smax, max( S, Smin ) );
end

[T, P] = adaptArguments (T, P);
S      = S * ones (length (T), 1);

% Calcul de la racine carrée de S %
SR = sqrt(abs(S));

% Terme en S^2	%
D = (1.727e-3) - (7.9836e-6)*P;

% Terme en S^3/2 %
B1 = 7.3637e-5 + 1.7945e-7*T;
B0 = -1.922e-2 - 4.42e-5*T;
B  = B0 + B1.*P;

% Terme en S^1 %
A3 = (-3.389e-13*T + 6.649e-12).*T + 1.100e-10;
A2 = ((7.988e-12*T - 1.6002e-10).*T + 9.1041e-9).*T - 3.9064e-7;
A1 = (((-2.0122e-10*T + 1.0507e-8).*T - 6.4885e-8).*T - 1.2580e-5).*T + 9.4742e-5;
A0 = (((-3.21e-8*T + 2.006e-6).*T + 7.164e-5).*T - 1.262e-2).*T + 1.389;
A  = ((A3.*P + A2).*P + A1).*P + A0;

% Terme en S^0 %
C3 = (-2.3643e-12*T + 3.8504e-10).*T - 9.7729e-9;
C2 = (((1.0405e-12*T - 2.5335e-10).*T + 2.5974e-8).*T - 1.7107e-6).*T + 3.1260e-5;
C1 = (((-6.1185e-10*T + 1.3621e-7).*T - 8.1788e-6).*T + 6.8982e-4).*T + 0.153563;
C0 = ((((3.1464e-9*T - 1.47800e-6).*T + 3.3420e-4).*T - 5.80852e-2).*T + 5.03711).*T + 1402.388;
C  = ((C3.*P + C2).*P + C1).*P + C0;

% Calcul final de la célérité %
Cel = C + (A + B.*SR + D.*S).*S;


%!demo
%! S = 35;
%! P = 0;
%! T = -2:40;
%! plot (T, celerity (T, P, S))
%! xlabel ("Temperature en Degres C")
%! ylabel ("Celerite en m/s")
%! title ("Salinite 35 P.S.U., pression atmospherique")
%! grid on

