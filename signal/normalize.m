function [ buffout, errmsg ] = normalize( buffin, NFen, NTrou, Sn )

errmsg = [];

% Valeurs par defaut des arguments
DNFen  = 10;
DNTrou = 4;
DSn    = 5; %3 dB???

% Lectures des arguments d'entree
switch( nargin )
   
	case 1,
   NFen  = DNFen;
   NTrou = DNTrou;
   Sn    = DSn;
   
	case 2,
   NTrou = DNTrou;
   Sn    = DSn;
   
   case 3,
   Sn    = DSn;
   
	case 4,
   
	otherwise,
   errmsg  = 'NORMALIZE ERROR. Bad number of arguments.';
   buffout = [];
   return;
   
end

% Initialisation
[ R, N ] = size( buffin );
if( R > N )
   buffin = buffin';
   [ R, N ] = size( buffin );
end
buffout  = zeros( R, N );
buffA    = zeros( NFen, 1 );
buffB    = zeros( NFen, 1 );

if( ( NTrou + 2 * NFen ) > N )
   errmsg  = 'NORMALIZE WARNING. Buffer too small, out same as in.';
   buffout = buffin;
   return;
end

% Boucle de calcul
for( r = 1 : R )
   
   for( n = 1 : N )
   
   	mA = + Inf;
   	mB = + Inf;
   
   	% Selection de la fenetre a gauche du trou
   	if( n > ( NFen + ceil(NTrou/2) - 1 ) )
         buffA = buffin( r, ( n - NFen - ceil(NTrou/2) + 1 ):( n - ceil(NTrou/2) ) );
         mA    = mean( buffA );
         vA    = var( buffA );
      end
            
      % Selection de la fenetre a droite du trou
   	if( n < ( N - ( NFen + floor(NTrou/2) - 1 ) ) )
      	buffB = buffin( r, ( n + floor(NTrou/2) + 1 ):( n + NFen + floor(NTrou/2) ) );                  
         mB    = mean( buffB );
         vB    = var( buffB );
      end
      
      % Moyenne et variance
      if( abs( mA - mB ) < Sn )
         m = mean( [ mA, mB ] );
      	v = mean( [ vA, vB ] );
      else
         if( mA < mB )
      	   m = mA;
         	v = vA;
      	else
				m = mB;
         	v = vB;
      	end
      end
      % Normalisation
    if( v )
      	buffout( r, n ) = ( buffin( r, n ) - m ) / v;
   	else
      	buffout( r, n ) = ( buffin( r, n ) - m );
   	end
      
   end
   
end

if( ~nargout )
   
   figure;
   subplot( 2, 1, 1 )
   plot( buffin );
   grid on;
   xlabel( 'Donnees Brutes' );
   subplot( 2, 1, 2 );
   plot( buffout );
   grid on;
   xlabel( sprintf( 'Fenetre %d, Trou %d, Seuil %d', NFen, NTrou, Sn ) );
   clear buffout;
   return
   
end


   