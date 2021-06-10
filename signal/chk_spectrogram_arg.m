function [ errmsg, chunksize, nfft, jump, window ] = chk_spectrogram_arg( argin )

% Messages d'erreur
error0 = [ 'SPECTROGRAM ERROR. Invalid number of arguments' ];
error1 = [ 'SPECTROGRAM ERROR. The number of samples for computing the fft must be greater or equal than the chunks size.' ];
error2 = [ 'SPECTROGRAM ERROR. The number of samples overlaped must be less than the chunks size.' ];
error3 = [ 'SPECTROGRAM ERROR. Window and chunks must have the same number of samples.' ];
error4 = [ 'SPECTROGRAM ERROR. Overlap must be less than chunksize' ];

errmsg    = [];
chunksize = [];
nfft      = [];
overlap   = [];
jump      = [];
window    = 0;

% recherche de l'argument contenant la fenetre
N = length( argin );
for( n = 1 : N )
   window = argin{ n };
   if( ischar( window ) )
      %la fenetre est passee par nom
      argin = { argin{1:(n-1)}, argin{(n+1):end} };
   else
      window = 0;
   end
   if( length( window ) > 1 )
      %la fenetre est passee explicitement
      argin = { argin{1:(n-1)}, argin{(n+1):end} };
   else   
      window = 0;
   end
end

% argin devient argin sans la fenetre
switch( length( argin ) )
   
	case 0,
	chunksize = 1024;
	nfft      = chunksize;
   jump      = round( chunksize * 0.5 );
      
   case 1,
   chunksize   = argin{ 1 };
	nfft        = chunksize;
   jump        = round( chunksize * 0.5 );
   
	case 2,
	chunksize = argin{ 1 };
	nfft      = argin{ 2 };
   jump      = round( chunksize * 0.5 );
   
	case 3,
	chunksize = argin{ 1 };
	nfft      = argin{ 2 };
   overlap   = argin{ 3 };
   if( overlap < 1 )
      % Overlap est une fraction
      jump = round( chunksize * ( 1 - overlap ) );
   else
      % Overlap est un nombre d'echantillons
      jump = chunksize - overlap;
   end
      
   otherwise,
   window    = 0;
   return

end

if( ~window )
   % Fenetre par defaut
   window = ones( chunksize, 1 );
else
   if( ischar( window ) )
      window = feval( window, chunksize );
   end
end

% Verification de la coherence des arguments
if( nfft < chunksize )
   errmsg = error1;
end
if( overlap < 0 )
   errmsg = error2;
end
if( chunksize ~= length( window ) )
   errmsg = error3;
end
if( jump <= 0 )
   errmsg = error4;
end
