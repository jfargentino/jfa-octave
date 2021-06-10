function signal= ispectrogram( fft_array, varargin )

%disp('Modifier le chk_arg')
%disp('Aide en ligne')
%disp('fenetre de synthese & recouvrement')
%disp('optimisation')
%disp('lecture a partir d''un fichier m')

[ errmsg, chunksize, nfft, jump, window ] = chk_spectrogram_arg( varargin );
if( errmsg )
   signal = [];
   error( errmsg );
end

% C est le nb de spectres
[nfft,C]  = size( fft_array );

% N La taille du signal
N = ( C + 1 ) * jump;

% Allocation du tableau de sortie
signal = zeros( N, 1 );

% Generation de la fenetre duale
window = dualwin( window, jump );

% On calcul toutes les ifft d'un coup
fft_array = ifft( fft_array );

% On remplace les blocs temporels dans le signal
for( c = 1 : C )
   n = ( c - 1 ) * jump + 1;
   %signal( n:(n+chunksize-1) ) = fft_array( 1:chunksize, c ) .* window;
   signal( n:(n+chunksize-1) ) = signal( n:(n+chunksize-1) ) + fft_array( 1:chunksize, c ) .* window;
end

% boucle de calcul, C ifft sont calculees
%for( c = 1 : C )
%
%   n = ( c - 1 ) * jump + 1;
%   signal( n:(n+chunksize-1) ) = ifft( fft_array( :, c ) );
%   
%end

signal = [ 0 ;chunksize * signal / 2 ];