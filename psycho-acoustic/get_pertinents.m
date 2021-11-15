function [tones, noises, cbt] = get_pertinents( sig, fs, nb, bw, tnmr, win )
%
%function [tones, noises] = get_pertinents( signal, fs )
%function [tones, noises] = get_pertinents( signal, fs, nb )
%
%    GET_PERTINENTS sort les composantes pertinantes de 'signal', un tableau des 
%echantillons espaces de la periode 1/'fs'. 'tones' est un tableau de
%2*'nb' cases ('nb'=20 par defaut, si 'nb'=0, tous les tons pertinant
%seront gardes), ou la premiere ligne represente les frequences, et la 
%deuxieme les amplitudes correspondantes. A noter que 'tones' est classe
%selon les amplitudes decroissantes. 'noises' est un vecteur de 25 elements,
%le i-eme coefficient etant l'ecart type du bruit se situant entre (i-1) 
%et i bark. Taille conseillee du signal : 16384.
%   Si aucuns argument de sortie n'est precise, on enregistre les resultats
%dans un fichier texte portant le nom 'extract_' suivi du nom du fichier 
%wav traite, ou de la date et l'heure si le signal a ete passe en argument.
%    Attention tout de meme, si cette methode est efficace pour des signaux
%constitues de bruits, pour des signaux purement tonaux c'est pas genial
%car avec la fenetre par defaut (Hanning), l'etalement d'une raie spectrale
%fait que l'on va trouver du bruit alors qu'il n'y en a pas! Faire l'essais
%avec un sinus pur pour s'en persuader. De meme, si on effectue le traitement
%sur un bruit blanc, on va detecter des sinus, c'est evidement parce que la
%detection de tons est une simple detection de pic sur 5 points, mais une
%detection plus pointue ne laisse plus passer assez de tons dans un signal
%standard. Ce dernier probleme est tout de meme moins genant car les sinus
%detectes dans un bruit pur seront de toute facon inaudibles.
%
%
%function [tones, noises] = get_pertinents( signal, fs, nb, bw )
%
%    On precise en plus la largeur en bark de la fenetre glissante permettant
%la decimation des tons. 'bw' est a .5 par defaut. Si 'bw' est un tableau de
%2 cases, la premiere a le role explique precedement, la deuxieme designe la 
%largeur en bark des bandes de bruit (a 1 par defaut).
%
%
%function [tones, noises] = get_pertinents( signal, fs, nb, bw, tnmr )
%
%    Le coefficient (en dB) a partir duquel on considere qu'un ton est masque
%par le bruit contenut dans sa bande critique (i.e. la bande de largeur 'bw'
%bark centree geometriquement sur la frequence du ton). 'tnmr' est a 5dB par
%defaut.
%
%
%function [tones, noises] = get_pertinents( signal, fs, nb, bw, tnmr, win )
%
%    On peut egalement changer la fenetre de ponderation temporelle, qui est par
%defaut une fenetre de Hanning. Attention toutefois a ce que 'win' est la meme
%taille que 'signal' si c'est une puissance de 2, ou que la taille de 'win'
%soit egale a la puissance de deux immediatement superieure a la taille de
%'signal'.
%
%
%function [tones, noises] = get_pertinents( file, [nb, bw, tnmr, win] )
%
%    On peut egalement passer directement le nom d'un fichier wave en argument.
%
%
%REMARQUE : la ligne 132 de DECIMATION peut etre remplacee par la 133. C'est
%dans ce fichier que doit se concentrer les efforts pour ameliorer le procede.
%
%Voir aussi GET_PERT_DIR, MEAN_PERTINENTS, SYNTHETIZE, GET_ALL_TONES, GET_NOISES, DECIMATION.
%

%%%%%%%%%%%%%%
thr  = 5e-4; %
%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% on recupere les arguments %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if( ischar(sig) )
   
   [signal ffs b] = wavread(sig);
   N = length(signal);
   
   switch( nargin )
      
    case 1,
      fs   = ffs;
      nb   = 20;
      bw   = [.5, 1];
      tnmr = 5;
      win  = hanning(N);
      
      case 2,
      nb   = fs;
      fs   = ffs;
      bw   = [.5, 1];
      tnmr = 5;
      win  = hanning(N);
      
    case 3,
      bw   = nb;
      nb   = fs;
      fs   = ffs;
      tnmr = 5;
      win  = hanning(N);
      
    case 4,
      tnmr = bw;
      bw   = nb;
      nb   = fs;
      fs   = ffs;
      win = hanning(N);
      
    case 5,

      win  = tnmr;
      tnmr = bw;
      bw   = nb;
      nb   = fs;
      fs   = ffs;
      
    otherwise,
      disp('Error, invalid number of arguments.');
      return
      
   end%switch( nargin )
   

else% signal n'est pas un fichier mais un tableau   
   
   signal = sig;
   N = length(signal);

   switch( nargin )
      
    case 2,
      nb   = 20;
      bw   = [.5, 1];
      tnmr = 5;
      win  = hanning(N);
      
      case 3,
      bw   = [.5, 1];
      tnmr = 5;
      win  = hanning(N);
      
    case 4,
      tnmr = 5;
      win  = hanning(N);
      
    case 5,
      win = hanning(N);
      
    case 6,
      
    otherwise,
      disp('Error, invalid number of arguments.');
      return
      
   end%switcn( nargin )
   
end% if( ischar(sig) )

if( length( bw ) == 1 )
   bw = [bw, 1];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%% analyse du signal %%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
osize = N; %nb d'echantillons du signal d'origine
[freq tdsp dsp] = get_all_tones(signal,fs,thr,win);
[tdsp rdsp]     = decimation(dsp,tdsp,fs,nb,bw(1),tnmr);
%mise en tableau des partiels pertinant
%1ere ligne : frequences
%2eme ligne : amplitude
indx  = find(tdsp);
N     = length(tdsp);
incr  = fs / (2*N);
H     = length(indx);
tones = zeros(2,H);
if( length(indx) )
	tones(1,:) = incr*(indx'-1);
   tones(2,:) = 2*sqrt(tdsp(indx)');
else
   tones = [0, 0]';
end
%on recupere ce qui reste sous forme de bruit
noises     = get_noise_band(rdsp,fs,osize,bw(2:length(bw))); 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if( ~nargout )
   
   if( ischar(sig) )
      if( (strcmp(sig(length(sig)-3:length(sig)),'.wav')) )
         sig = sig(1:length(sig)-4);
      end
      file = ['pertinents_',sig];
   else
      file = ['pertinents_',now2str(now)];
    end%if( ischar(sig) )
   
   fid = fopen([file,'.txt'],'at');
   fprintf(fid,'Resultat de get_pertinents, %s...\n\n',file);
   fprintf(fid,'Parametres  nb:%d, bw(1):%f, bw(2):%f, tnmr:%f\n\n',nb,bw(1),bw(2),tnmr);
   tones2file(tones,fid);
   fprintf(fid,'\n');
   noises2file( noises, fid, ...
                ['Bande de bruit de largeur ', num2str(bw(2)),' bark.'] );
   fclose(fid);
   
   clear noises;
   clear tones;
   
end%if( nargout==0 )

%si le dernier arg 'cbt' de sortie est precise
if( nargout > 2 )
   
%Si bw(2) == 1...    
%   Barks = [ 0     101   204   308   417   530   651   781   ...
%            922   1079  1255  1456  1690  1968  2302  2711  ...
%            3211  3822  4554  5411  6414  7617  9166  11414 ...
%            15405 22050 ];

    n = 0:bw(2):25;
   N = length( n );
   Barks = bark2hz( n );
   Barks(1) = 20;
   Barks(N) = fs/2;
   cbt = [];
   row = 1;
   for( b=1:N-1 )
    indx = find( ( tones(1,:)>=Barks(b) ) & ( tones(1,:)<Barks(b+1) ) );
      if( length(indx) )
         cbt(1:2,row) = tones(:,min(indx));
         row = row+1;
      end%if( length(indx) )
   end%  for( b=1:25 )
   
end%if( nargout > 2 )
