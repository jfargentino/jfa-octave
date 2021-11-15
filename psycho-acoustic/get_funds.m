function out = get_funds( in, wid )
%
%fonction array_out = get_funds( array_in [, wid ] )
%
%   Recherche toutes les frequences qui ne sont pas 
%multiples d'une autre dans le tableau 'array_in'. On
%considere qu'une frequence f est multiple de f0 si
%existe n entier tel que:
%              abs( f0 - f/n ) <= wid/2
%ou 'wid' vaut 4 hertz par defaut.
%
%Voir aussi
%

switch( nargin )
case 1,
   wid = 4;
case 2,
otherwise
   return
end%switch

in = sort(in);
out(1) = in(1);
F = 2;

for( n=2:length(in) )
   m  = max(round(in(n)/in(1)),2);
   ok = 1;
   while( (ok) & (m>1) )
      if( ( length( find( abs(in(:)-in(n)/m)<=wid/2 ) ) ) | ...
          ( length( find( abs(in(:)-in(n)/(2*m))<=wid/2 ) ) ) )
         ok = 0;
      else
         m = m-1;
      end%if...
   end%while( (ok) & (m>1) )
   if( (m==1)&(ok) )
      %if( length( find( abs(tones(1,:)-tones(1,n)) <= wid/2 ) ) == 1 )
      	out(F) = in(n);
         F = F+1;
      %end%if( length( find( abs(tones(1,:)-tones(1,n))<=wid/2 ) ) ) > 1 )
   end%if( (m==1)&(ok) )
end%for( n=1:length(tones(1,:)) )
