function lpsd = get_lpsd(sig,fs,fig)
%
%function get_lpsd( sig )
%function get_lpsd( sig, fs )
%function get_lpsd( sig, fs, fig )
%function get_lpsd( wavfile, [ fig ] )
%function lpsd = get_lpsd(...)
%
%   Affiche le spectre de puissance en dB de 'sig' selon la frequence 
%d'echantillonnage 'fs' et le retourne sous la forme du vecteur 
%'lpsd' si ce dernier est precise, contenant egalement les 
%frequences negatives. 'fs' n'est necessaire que si on veut l'abscisse
%en hertz. Enfin on peut indiquer le numero de figure grace a 'fig'. 
%A noter qu'aucun fenetrage n'est effectue, donc c'est a la charge de 
%l'utilisateur de fenetrer avant l'appel de la fonction. Le zero-
%padding en revanche est fait.
%
%
%REMARQUE, on pourra eventuellement calculer la DSP par la methode de 
%reallocation ( FFT avec la fenetre derive, puis combinaison par la
%la FFT standard, ceci permettant de diminuer la largeur du lobe
%principal ). Demander a Florent pour plus de details.
%
%Voir aussi GET_PSD.
%

min_pwr = 17;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% on recupere les arguments %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if( ischar(sig) )
   switch( nargin )
    case 2,
      fig = fs;
         
    otherwise,
      if( nargin > 2 )
         disp('Error, invalid number of arguments.')
         return
      end
   end% switch(nargin )
   [sig fs b] = wavread(sig);
   nb_argin   = nargin + 1;
else
   nb_argin   = nargin;
end% if( ischar(sig) )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% on rend le signal colonne %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[N,M] = size(sig);
if( N==1 )
   sig = sig';
   N   = M;
end% if( N==1 )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% zero-padding %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%zero-padding pour dimensionner le signal a une 
%puissance de 2 et pour etre plus precis en amplitude
n   = max(floor(log2(N))+1,min_pwr);
M   = 2^n;
sig = [sig', zeros(1,M-N)]'; 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%% calcul de la DSP %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
lpsd  = 20*log10(abs(fft(sig))/N);
draw = lpsd(1:M/2);
lpsd  = fftshift(lpsd);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% affichage %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if( ~nargout )
   
   switch( nb_argin )
      
      case 1,
    plot(draw);
    
    case 2,
    plot(0:fs/M:fs/2-fs/M,draw);
    
    case 3,
    figure(fig);
    plot(0:fs/M:fs/2-fs/M,draw);
      
    otherwise,
      disp('Error, invalid number of argument')
      return
      
   end% switch( nb_argin )
   
   grid on;

    clear lpsd
   
end%if( ~nargout )
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
