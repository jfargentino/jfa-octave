function [ fft_array, sadjusted, errmsg ] = spectrogram( signal, varargin )
%
%function fft_array = spectrogram( signal, chunksize, nfft, overlap, window )
%

%disp('Aide en ligne')
%disp('Cas des signaux multivoies')

% Dynamique pour l'affichage
MIN_DB = -90;

% Lecture du signal a analyser
Fs = 0;
if( ischar( signal ) )
   switch( signal( end-2 : end ) )
   	case 'wav',
      [ signal, Fs, B ] = wavread( signal );
   	case '.au',
      [ signal, Fs, B ] = auread( signal );
   	otherwise,
      [ signal, Fs, B ] = wavread( signal );
   end
end

% Lecture des autres arguments
[ errmsg, chunksize, nfft, jump, window ] = chk_spectrogram_arg( varargin );
if( errmsg )
   fft_array = [];
   return
else
   errmsg = [];
end

% N est le nombre d'echantillons temporels
[N,C]  = size( signal );

% Si le signal est en ligne on le remet en colonne
if( N < C )
   signal = signal';
   n      = N;
   N      = C;
   C      = n;
end

% Sauvegarde du signal original
osignal= signal;
oC     = C;
oN     = N;
% On rend N multiple de jump
n      = jump - mod( N, jump );
N      = N + n;
% M est le nombre de blocs de fft pour une voie
M      = N / jump - 1;
% chunksize >= jump, il faut ajuster N
N      = N + ( chunksize - jump );
signal = [ signal ; zeros( N-length(signal), C ) ];
sadjusted = signal;
% Mise en vecteur colonne du signal
signal = signal( : );
N      = length( signal );
M      = M * C;

% Allocation du tableau de sortie
fft_array = zeros( nfft, M );

% On decoupe le signal comme il faut
padding   = zeros( nfft - chunksize, 1 );
for( m = 1 : M )   
   n = ( m - 1 ) * jump + 1;
   fft_array( :, m ) = [ signal( n : n+chunksize-1 ) .* window; padding ];
end
% Et on fait toutes les fft d'un coup
fft_array = 2 * fft( fft_array ) / chunksize;

%window    = repmat( [ window; zeros( nfft - chunksize, 1 ) ], 1, M );
%n         = repmat( ( 1 : nfft )', 1, M );
%m         = repmat( ( 0 : M - 1 ) * jump, nfft, 1 );
%n         = n + m;
%fft_array = 2 * fft( signal( n ) .* window ) / chunksize;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% La suite ne concerne que l'affichage si il %
% n'y a pas d'arguments de sortie specifies  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if( ~nargout )
   
   hf = figure;
   colormap( 'hot' );
   % Index des frequences
   Fi = 1 : ( nfft/2 + 1 );
   % Index des blocs FFT
   Ti = 1 : M;
   % Index des blocs de FFT par voie
   ti = 1 : round( M / C );
      
   if( Fs )
      soundsc( osignal, Fs, B );
      % F frequences
      F = Fs * ( Fi - 1 ) / nfft;
      % T temps
      T = ( ti - 1 ) * jump / Fs;
      subplot( 2, 1, 1 );
      plot( repmat( ( 0 : oN-1 )'/Fs, 1, oC ), osignal );
      xlabel( 'Secondes' );
      grid on;
      for( c = 1 : oC )
         subplot( 2, oC, oC + c  );
         Tmp = 20*log10( abs( fft_array( Fi, ( ti + (c-1)*length(ti) ) ) ) );
         dyn = [ max( MIN_DB, min( min( Tmp ) ) ), max( max( max( Tmp ) ), MIN_DB+1 ) ];
         imagesc( T, F, Tmp, dyn );
         axis xy;
         title( [ 'Voie ', num2str( c ) ] );
         xlabel( 'Secondes' );
         ylabel( 'Hz' );
         grid on;
   		colorbar;
      end
      
   else
      F = ( Fi - 1 ) / nfft;
      T = ( ti - 1 ) * jump;
      subplot( 2, 1, 1 );
      plot( osignal );
      xlabel( 'Echantillons' );
      grid on;
      for( c = 1 : oC )
         subplot( 2, oC, oC + c );
         Tmp = 20*log10( abs( fft_array( Fi, ( ti + (c-1)*length(ti) ) ) ) );
         dyn = [ max( MIN_DB, min( min( Tmp ) ) ), max( max( max( Tmp ) ), MIN_DB+1 ) ];
         %imagesc( T, F, Tmp, dyn );
         imagesc( Tmp, dyn );
         axis xy;
         title( [ 'Voie ', num2str( c ) ] );
         xlabel( 'Echantillons' );
         ylabel( 'Frequences normalisees' );
         grid on;
   		colorbar;
      end
   end
   clear fft_array
   clear sadjusted
end
