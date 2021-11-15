function [out1, out2, out3] = synthetize( tones, noises, adjust, fs, s, nf )
%
%function signal = synthetize( tones )
%function signal = synthetize( tones, noises )
%
%   SYNTHETIZE reconstitue 'signal' a partir des composantes tonales
%'tones' et des 25 bruit de bande 'noises', qui sont les sorties de
%la fonction GET_PERTINENTS. Par defaut le signal de sortie est un tableau de
%32768 echantillons espaces de 2.2676e-005 s, soit une frequence
%d'echantillonage de 44,1kHz.
%
%
%function signal = synthetize( tones, noises, adjust )
%
%   Il n'est pas rare que le bruit dans le son de synthese prenne trop
%d'importance. Cela dependant apparement du type de son, on pourra ajuster
%le niveau de bruit grace au coefficient multiplicateur 'adjust' (1 par defaut).
%Si 'adjust' est egale a .8, on diminuera de 20% le niveau general du bruit.
%
%
%function signal = synthetize( tones, noises, adjust, fs )
%
%   On peut preciser grace a 'fs', une frequence d'echantillonnage differente
%de 44,1kHz. Le nombre d'echantillons etant toujours de 32768.
%
%
%function signal = synthetize( tones, noises, adjust, fs, s )
%
%   On peut egalement preciser la longueur en secondes du signal synthetize.
%
%
%function [tonal, noisy] = synthetize( ... )
%
%   Il est possible de recuperer la partie du signal uniquement constituee de
%tons ('tonal'), et de meme la partie bruit de bande ('noisy'). On a donc la
%relation 'signal' = 'tonal' + 'noisy'.
%
%
%function [signal, fs, b] = synthetize( ... )
%
%   On sort en plus de 'signal' la frequence d'echantillonnage 'fs' et le nombre
%de bits qui code (16), ceci permettant d'avoir une sortie homogene a celle de
%WAVREAD.
%
%
%Voir aussi GET_PERTINENTS, MEAN_PERTINENTS, GET_PERT_DIR.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% on recupere les arguments %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch( nargin )
   
case 1,
   noises = 0;
   adjust = 1;   
   fs = 44100;
   s  = 32768/fs;
   nf = 0;
   
case 2,
   adjust = 1;
   fs = 44100;
   s  = 32768/fs;
   nf = 0;
   
case 3,
   fs = 44100;
   s  = 32768/fs;
   nf = 0;
   
case 4,
   s  = 32768/fs;
   nf = 0;
   
case 5,
   nf = 0;
   
otherwise,
   if( nargin~=6 )
      disp('Error, invalid number of arguments.')
   return
   end% if( nargin~=4 )
   
end% switch( nargin )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% construction de la partie tonale %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tt    = 2*pi*(0:1/fs:s)';
T     = length(tt);
if( mod(T,2)~=0 )
   T  = T-1;
   tt = tt(1:T);
end% if( mod(T,2)~=0 )

tonal = zeros(length(tt),1);

[M N]  = size(tones);
for( n = 1:N )
   %tonal = tonal + tones(2,n)*sin(tones(1,n)*(tt+randn(1,1)));
   tonal = tonal + tones(2,n)*sin(tones(1,n)*tt);
end% for( n = 1:N )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% construction de la partie bruitee %%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N      = length( noises );
Barks  = [ bark2hz(0:25/N:25-25/N), fs/2 ];
Barks(1) = 20;
noisy  = randn(T,1);
Freq   = round(T*Barks./fs);
snoise = fft(noisy);
Phi    = angle(snoise);
Amp    = abs(snoise);
Amp    = Amp(1:T/2);
noises = adjust * noises;
for( n=1:N )
   Amp(Freq(n)+1:Freq(n+1)) = noises(n)*Amp(Freq(n)+1:Freq(n+1));
end% for( n=1:25 )
Amp    = [Amp' zeros(1,T/2)]';
Amp    = Amp + flipud(Amp);
snoise = Amp.*exp(i*Phi);
noisy  = real(ifft(snoise));
signal = tonal+noisy;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%% la sortie %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
switch( nargout )
   
    case 0,
   if( nf )
      signal = signal ./ max(abs(signal));
   end
   wavwrite( signal, fs, 16, ['SYNTH_',now2str] );
   
    case 1,
   if( nf )
      out1 = signal/max(abs(signal));
   else
      out1 = signal;
   end
     
    case 2,
   if( nf )
    out1 = tonal/max(abs(signal));
    out2 = noisy/max(abs(signal));
   else
      out1 = tonal;
    out2 = noisy;
   end
   
    case 3,
   if( nf )
      out1 = signal/max(abs(signal));
   else
      out1 = signal;
   end
   out2 = fs;
   out3 = 16;
   
end% switch( nargout )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
