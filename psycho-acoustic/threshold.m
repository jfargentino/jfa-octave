function thr = threshold( f )
%
%function thr = threshold( f )
%
%   Calcul du seuil absolue d'audition en fonction
%de la frequence, ce seuil est en general donne en
%dB SPL, mais ici il est en echelle lineaire.
%
%
%function threshold( f )
%
%   Si aucun argument n'est precise en sortie, on
%affiche la ponderation du seuil d'audition.
%

thr = 10.^( ((3.64*(f'/1000).^(-0.8) ...
            - 6.5*exp(-0.6*(f'/1000 - 3.3).^2)) ...
            + (1e-3)*((f'/1000).^4))./10 );
         
%plus lisible mais plus lent ?  
%thr = 3.64*(f'/1000).^(-0.8);
%thr = thr - 6.5*exp(-0.6*(f'/1000 - 3.3).^2);
%thr = thr + (1e-3)*((f'/1000).^4);
%thr = 10.^(thr./10);

if( ~nargout )
   plot(f,10*log10(thr))
   grid on
   xlabel('Frequences en Hz')
   ylabel('Pression acoustique en dB SPL') 
   clear thr
end
