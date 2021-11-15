function noises = get_noise_band(PSD,fs,osize,nbw)
%
%function noises = get_noise_band( PSD, fs, osize [, nbw ] )
%
%   GET_NOISES effectue une moyenne de la DSP 'PSD' pour les
%bandes de largeur 'nbw' bark (1 bark par defaut), le vecteur
%'noises' contient alors les coefficients par lesquels il faut
%multiplier chacune des bandes de bruit pour retrouver la DSP
%'PSD'. Si 'nbw' est nul, on retourne la DSP 'PSD' telle 
%qu'elle, attention alors de ne pas appeler SYNTHETIZE avec
%ce tableau car le traitement risque de durer longtemps pour 
%un resultat faux. Le parametre 'osize' est la taille d'origine
%du signal, sans zero padding.
%
%
%Voir aussi GET_PERTINENTS, GET_ALL_TONES, DECIMATION, SYNTHETIZE.
%

%on remarque tres souvent un ecart
%de 10 a 20% sur la valeur energetique
adjust = .85;

if( nargin < 4)
   nbw = 1;
end

if( ( nbw < 0 ) | ( nbw > 25 ) )
   nbw = 1;
end

if( nbw == 0 )
   noises = PSD;
   return;
end

if( length( nbw ) > 1 )
   Barks = sort(nbw);
   if( Barks(length(Barks)) >= fs/2 )
      Barks(length(Barks)) = fs/2;
   else
      Barks = [ Barks, fs/2 ];
   end
   N = length( Barks );
else
   n = 0:nbw:25;
   N = length( n );
   Barks = bark2hz( n );
   Barks(1) = 20;
   Barks(N) = fs/2;
end

NP     = length(PSD);
Index  = round(2*NP*Barks/fs)+1;
noises = zeros(N-1,1);

for( n=1:N-1 )
   noises(n) = adjust * sqrt( osize * mean( PSD(Index(n):Index(n+1)-1) ) );
end% for( n=1:N )

%Si nbw=1 le tableau Barks c'est ca:
%Barks = [ 20    101   204   308   417   530   651   781   ...
%          922   1079  1255  1456  1690  1968  2302  2711  ...
%          3211  3822  4554  5411  6414  7617  9166  11414 ...
%          15405 fs/2];
