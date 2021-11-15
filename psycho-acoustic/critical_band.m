function [f_down, f_up] = critical_band( f, bw )           
%
%function [f_down, f_up] = critical_band( f, bw )
%
%   CRITICAL_BAND donne les frequences (en Hz) limites
%basse ('f_down') et haute ('f_up') de la fenetre centree
%geometriquement sur 'f' (en Hz) dont la largeur est de
%'bw' (en Bark). On a donc :
%             _______________
%       \    /
%  f  =  \  /  f_down * f_up    et  ( f_up - f_down ) = bw
%         \/
%
%Voir aussi HZ2BARK, BARK2HZ.
%

if( bw==0 )
   f_down = f;
   f_up   = f;
   return;
end% if( bw==0 )

bw     = (25 + 75*(1 + 1.4*(f/1000).^2).^0.69).*bw;          
delta  = ( 1 - 2*f./bw + sqrt((2*f./bw).^2 + 1) )./2;       
f_down = f - (1-delta).*bw;                                 
f_up   = f + delta.*bw;                                     

%!demo
%!
%!  [f_down, f_up] = critical_band( (20:10:640)', 1 )
%!
