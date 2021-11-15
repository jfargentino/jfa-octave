function [freq, peak, dsp] = get_all_tones( signal, fs, thr, win )
%
%function freq = get_all_tones( signal, fs [,thr, win ] )
%
%   Retourne toutes les frequences detectees dans le signal
%sous la forme d'un vecteur ligne 'freq'. La methode utilisee
%est une convolution entre la DSP de 'signal', puis une 
%detection des sommets sur 3 points. On detecte tout de meme
%des frequences pures au milieu d'un bruit... Il faudra peut
%etre effectuer un lissage du produit de convolution...
%On peut preciser un seuil de validite des pics detectes,
%c'est a dire que ne pourra etre considere comme partielle que
%les pics superieurs ou egaux au maximum de la DSP multiplie
%par 'thr', 'thr' valant 5e-4 par defaut. On peut aussi
%utiliser une fenetre autre que hanning grace a 'win'.
%
%
%function [freq peak] = get_all_tones( ... )
%function [freq peak dsp] = get_all_tones( ... )
%
%   Effectue le meme traitement en retournant en plus la DSP 
%uniquement constituee des frequences pures trouvees dans 
%'signal', et la DSP reelle.
%
%
%function [...] = get_all_tones( wav_file [, thr, win ] )
%
%   On peut egalement passer directement en entree un 
%fichier au format wav.
%
%
%REMARQUE, on pourra peut etre implementer un lissage de la dsp
%convoluee pour etre plus robuste par rapport au bruit.
%
%Voir aussi GET_PERTINENTS, GET_HARMONICS.
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fmin = 20;                                       %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nn   = 50;%autour du max de la dsp de la fenetre %
%a ameliorer passque on doit pouvoir faire mieux%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% on recupere les arguments %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if( (ischar(signal)) )
   [signal ffs b] = wavread(signal);
   switch( nargin )
    	case 1,
      win = hanning(length(signal));
      thr = 5e-4;
      
    	case 2,
      thr = fs;
      win = hanning(length(signal));
      
    	case 3,
      win = thr;
      thr = fs;
      
    	otherwise,
    	disp('Error, invalid number of arguments.')
      return   
   end%switch( nargin )
   fs = ffs;
   
else%( signal not a file )
   switch( nargin )
      case 2,
      thr = 5e-4;
      win = hanning(length(signal));
   
      case 3,
      win = hanning(length(signal));
      
      case 4,
         
      otherwise,
    	disp('Error, invalid number of arguments.')
      return   
   end%switch( nb_argin )

end% if( ischar(signal) )

if( thr > 1 )
   disp('Warning, the threshold must be less or equal')
   disp('to 1, a value of 10^-3 is taken instead.')
   thr = 5e-4;
end%if( thr > 1 )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% on rend le signal colonne %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[N,M] = size(signal);
if( N==1 )
   signal = signal';
   N      = M;
end% if( N==1 )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% on fenetre et on calcul la DSP %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if( length(win) ~= N )
   disp('Warning, the window you choose haven''t the')
   disp('same size that your signal, a hanning window')
   disp('is taken instead.')
   win = hanning(N);
end% if( length(win) ~= N )
%calcul de l'image frequentielle de la fenetre
%et normalisation pour que le max soit a 1
swin  = (fftshift(abs(fft([win' zeros(1,M-N)]'))/N));
[v,m] = max(swin);
win   = win/v;
dsp   = get_psd(signal.*win);
M     = length(dsp);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% on convolue la DSP par l'image de la fenetre %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%swin  = (swin(m-nn:m+nn)/v).^2;
%convo = conv(swin,dsp);
%convo = fftshift(convo);
convo = fftshift(conv((swin(m-nn:m+nn)/v).^2,dsp));
convo = convo(1:M/2);
dsp   = fftshift(dsp);
dsp   = dsp(1:M/2);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%% on recherche les pics dans CONVO %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Imin     = round(M*(Fmin/fs));
thr      = max(convo(Imin:M/2))*thr;
peak     = zeros(M/2,1);

%methode la plus rapide mais 
%moins blindee contre le bruit
n        = find(convo<thr);
convo(n) = 0;
indx     = [0 find(diff(convo)<0)'];
n        = find(diff(indx)>1)+1;
peak(indx(n)) = dsp(indx(n));

%methode bien plus lente mais
%plus robuste au bruit et aux
%lobes secondaires
%for( n=3:M/2-2 )
%   if( ( convo(n)>=thr ) & ...
%       ( convo(n)>convo(n-1) ) & ( convo(n)>convo(n+1) ) & ...
%       ( convo(n-1)>convo(n-2) ) & ( convo(n+1)>convo(n+2) ) )
%      peak(n) = dsp(n);
%   end% if( ... )
%end% for( n=3:M/2-2 )

%on affiche si il n'y a pas d'arguments de sortie
if( ~nargout )
   %plot(0:fs/M:fs/2-fs/M,10*log10(peak),'k',0:fs/M:fs/2-fs/M,10*log10(dsp),'r:')
   plot(0:fs/M:fs/2-fs/M,(peak),'r-',0:fs/M:fs/2-fs/M,(dsp),'b:')
   title([num2str(length(find(peak))),' frequence(s) detectee(s).'])
   grid on
   clear peak
   clear dsp
else%( nargout~=0 )
    indx = find(peak);
   freq = (indx-1)'*(fs/M);
end% if( ~nargout )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
