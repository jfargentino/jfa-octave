function Harm = get_harmonics( sig, fs, F0, wid, thr, win )
%
%function Harm = get_harmonics( signal, fs , F0 )
%
%   Recuperation de la (les) suite(s) harmonique(s) contenue(s) dans 'signal',
%(un tablean d'echantillons espace de 1/'fs') et dont la (les) fondamentale(s)
%sont proches de 'F0' a 0.25% pres, si aucune frequence n'est detectee autour 
%de 'F0', un message est affiche mais la detection est tout de meme effectue. 
%'Harm' est une CELL, la n-ieme suite harmonique sera donc accessible par 'Harm{n}',
%la premiere ligne etant la frequence et la deuxieme l'amplitude. 'F0' peut egalement
%etre un tableau de frequences fondamentales. Attention tout de meme que si 'F0' ne
%contient que deux frequences, la signification est differente, voir le paragraphe
%suivant.
%   La methode utilisee est la suivante : on recupere la frequence fondamentale
%et on cree a partir de celle-ci une sequence de 5 diracs, on multiplie alors points
%a points cette sequence avec la DSP tonale du signal, on regarde quel est le dernier
%echantillon non nul, on divise la frequence correspondante par son ordre et on
%affine ainsi la precision de la frequence fondamentale, puis on recommence avec une
%sequence de 10 diracs... On arrete la boucle lorsque l'ordre de la plus grande
%harmonique detectee est le meme que le tour precedent.
%   Si l'argument de sortie 'Harm' est absent, la fonction enregistre les resultats
%dans un fichier texte, dans le meme repertoire et portant le prefixe 'harmonics_'.
%
%
%function Harm = get_harmonics( signal, fs )
%function Harm = get_harmonics( signal, fs, [F0min, F0max] )
%
%   On recupere toutes les sequences harmoniques dont le fondamental est situe
%entre 'F0min' et 'F0max', si ces deux derniers sont egaux, le traitement est 
%le meme que si une seule frequence est precisee. Par defaut 'F0min' = 20 Hz et
%'F0max' = 11025 Hz.
%
%
%function Harm = get_harmonics( signal, fs, F0, wid )
%
%   Le parametre 'wid' permet de specifier la largeur en Hertz des dirac 
%utilises pour la detection. Si en theorie elle devrait etre de 0, cela serait trop
%restrictif lorsque le pas d'incrementation frequentiel est tres fin. Par defaut
%'wid' est fixe a 2 Hz. 
%
%
%function Harm = get_harmonics( signal, fs, F0, wid, thr, win )
%
%   Les deux derniers parametres sont uniquement destines a la fonction
%GET_ALL_TONES, voir l'aide en ligne de cette derniere pour plus de precisions.
%
%
%function Harm = get_harmonics( wavfile [, F0, wid, thr, win ] )
%
%   Le premier argument peut egalement etre un fichier au format .wav.
%
%
%REMARQUE, il arrive que des frequences apparaissent plusieurs fois dans la sequence
%          avec des amplitudes differentes.
%          
%Voir aussi GET_HARM_DIR, MEAN_HARMONICS, GET_ALL_TONES, dirac_sequence.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fmin = 40; Fmax = 11025;                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nb_sup = 5;                                                          %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
defstr = 'j$tB';                                                     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if( (ischar(sig)) )
   [signal ffs b] = wavread(sig);
   N = length(signal);
   switch( nargin )
    	case 1,
      F0    = [Fmin, Fmax];
      wid   = 4;
      thr   = 5e-4;
      win   = hanning(N);
      
   	case 2,
      F0    = fs;
      wid   = 4;
      thr   = 5e-4;
      win   = hanning(N);
      
   	case 3,
      wid   = F0;
      F0    = fs;
      thr   = 5e-4;
      win   = hanning(N);
      
   	case 4,
      thr   = wid;
      wid   = F0;
      F0    = fs;
      win   = hanning(N);
      
    	case 5,   
      win   = thr;
      thr   = wid;
      wid   = F0;
      F0    = fs;
      
   	otherwise,
      disp('Error, invalid number of arguments.')
      return
       
   end%switch( nb_argin )
   fs = ffs;
   
else
   signal = sig;
   N = length(signal);
   switch( nargin )
      
   	case 2,
      F0    = [Fmin, Fmax];
      wid   = 4;
      thr   = 5e-4;
      win   = hanning(N);
   
   	case 3,
      wid   = 4;
      thr   = 5e-4;
      win   = hanning(N);
      
   	case 4,
    	thr   = 5e-4;
      win   = hanning(N);
      
   	case 5,
      win   = hanning(N);
         
   	case 6,
      
    	otherwise,
      disp('Error, invalid number of arguments.')
    	return   
   end%switch( nb_argin )

end% if( ischar(signal) )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%  on detecte les frequences  %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[freq, tpsd] = get_all_tones(signal,fs,thr); 

LL   = length(tpsd);
incr = fs/(2*LL);
Imin = round(Fmin/incr) + 1;

if( length(F0)==2 )
   if( F0(1)==F0(2) )
      F0(1) = F0(1)-wid/2;
      F0(2) = F0(1)+wid;
   end
   indx  = find( (freq>=F0(1))&(freq<=F0(2)) );
   if( ~length(indx) )
    disp(['Warning, no frequency between ',num2str(F0(1)) ,' and ', num2str(F0(2)),' Hz in the signal ', sig])
    freq = [F0(1):incr:F0(2)];   
    else
    freq = freq(indx);
    end%if( ~length(indx) )

else%( length(F0)~=2 )
   indx = [];
   for( n=1:length(F0) )
      F0min = F0(n)-wid/2;
      F0max = F0(n)+wid/2;
      indx  = [indx, find( (freq>=F0min)&(freq<=F0max) )];
   end%for
   if( length(indx) )
      freq = freq(indx);
   else
      disp(['Warning, any frequency you''ve select were found in the signal ', sig])
      Harm = {};
      return
   end
end

%les frequences a partir desquelles on va 
%chercher des suites harmoniques...
LF   = length(freq);
Harm = cell(0);
nb_H = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%% L'usine a gaz commence ici %%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for( f=1:LF )%pour toutes les freq detectees
   
   ok   = 1;
   N    = round(freq(f)/freq(1));
   %n    = 2;
   
   %esque la frequence est une harmonique?
   %esquon peut ameliorer? par ex. enlever du
   %tableau freq les harmoniques deja detectees.
   while( (ok)&(N>1) )
      if( (length( find( abs( freq(:)-freq(f)/N) <= wid/2 ) )) | ...
          (length( find( abs( freq(:)-freq(f)/(2*N)) <= wid/2 ) )) )
         ok = 0;
      else
         N = N-1;
      end
   end%while( (ok)&(N>1) )   
   
   if( ok )%si la freq est une fondamentale
      
      cha    = 1;
      porder = 0;
      order  = 1;
      nb     = nb_sup;
      pf0    = 0;
      f0     = freq(f);
      oct    = floor(fs/(2*f0));
      
      %on affine la valeur de la fondamentale 
      %pour detecter un maximum d'harmoniques
      %Le principe : on cree une sequence de nb
      %portes, on detecte la derniere harmonique
      %et on la divise par son ordre, on ameliore
      %ainsi la precision de la fondamentale et
      %on recommence avec la nouvelle fondamentale
      %et plus de portes...
      while( cha & ( nb<=oct ) )
         match  = tpsd.*dirac_sequence(f0,nb,fs,LL,wid);
         pf0    = f0;
         fh     = find(match);
         l      = length(fh);
         if( l )
            fh     = fh(l)-1;
            fh     = fh*incr;
            porder = order;
            order  = round(fh/pf0);
            f0     = fh/order;
            oct    = floor(fs/(2*f0));
            if( ( porder == order ) | ( abs(f0-freq(f)) > incr/2 ) )
                cha = 0;
            end%( ( porder == order ) | ( abs(f0-freq(f)) > incr/2 ) )
            nb    = order + nb_sup + 1;
         else%( l==0 )
            cha   = 0;
         end%if( l )
         
      end%while( cha & ( nb<=oct ) ) 
      
      %on detecte les harmoniques et on regarde 
      %egalement au cas ou la fondamentale est absente
      match1 = tpsd.*dirac_sequence(f0,0,fs,LL,wid);
      match2 = tpsd.*dirac_sequence(f0/2,0,fs,LL,wid);
      fm1    = find(match1);
      fm2    = find(match2);
            
      if( length(fm1) >= length(fm2) - 1 )
      %si la fondamentale est bien presente
         fm    = fm1;
      else%( length(fm1) < length(fm2) )
      %si la fondamentale est absente
          f0    = f0/2;
         if( (fm2(1) ~= round(f0/incr)+1) & (fm2(1) ~= round(f0/incr)+2) )
            fm = [round(f0/incr)+1 fm2']';
         else
            fm = fm2;
         end
      end%if( length(fm1) >= length(fm2) )

      harms = (fm-1)*incr;
      
      %on les sauvegarde dans une cellule de Harm
      if( length(harms) )
        tmp        = zeros(2,length(harms));
        tmp(1,:)   = harms';
        tmp(2,:)   = 2*sqrt(tpsd(fm))';
        tmp        = fusion(tmp,tmp);
        Harm{nb_H} = tmp;
        nb_H       = nb_H+1;
      end%if( length(harms) )
      
   end%if( ok )
   
end% for( f=1:LF )

Harm = cell_sort(Harm);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ( ~nargout )
   if(ischar(sig))
      str = sig;
   else
      str = now2str(now);
   end
   cell2file(Harm,['harmonics_', str], ...
             ['Analyse du signal ', str, ' entre ', num2str(F0(1)), ' et ', num2str(F0(length(F0))), ...
              ' Hz. Tolerance ', num2str(wid), ' Hz.'], ...
              1 );
   clear Harm;
end
