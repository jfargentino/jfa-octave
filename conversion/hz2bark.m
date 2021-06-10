function bark = hz2bark( hz )
%
%function barks = hz2bark( hz )
%
%   HZ2BARK convertie les Hertz en Bark suivant la formule:
%
%    bark = 13*atan((7.6e-4)*hz) + 3.5*atan((hz/7500).^2)
%
%
%Voir aussi BARK2HZ, CRITICAL_BAND.
%

bark = 13*atan((7.6e-4)*hz) + 3.5*atan((hz/7500).^2);
