function [tones, noises, cbt] = mean_pertinents( files, nb, wid, bw, tnmr )
%
%function [tones, noises] = mean_pertinents( files [, nb, wid, bw, tnmr] )
%
%   On donne une cell de noms de fichiers wav 'files' senses representer
%le meme son, alors on moyenne toutes les frequences pertinentes trouvees
%ainsi que les 25 bandes de bruit. Cette fonction prend les memes arguments 
%d'entree que GET_PERTINENTS. Si on ne precise aucun des arguments de sortie
%on enregistre les resultats dans un fichier texte nomme 'mean_pert' suivi
%de la date et de l'heure. Les partiels sont ranges dans l'ordre decroissant
%de leur importances, la colonne 'hits' precisant dans combien de fichier
%la frequence a ete trouvee et selectionnee.
%
%
%function [ tones, noises, cbt ] = mean_pertinents( ... )
%
%   Si l'argument de sortie 'cbt' est precise, c'est un tableau au meme
%format que tones (2 lignes, la premiere les frequences, la deuxieme
%les amplitudes correspondantes), mais il ne contient que le partiel
%juge le plus pertinent pour chacune des bandes critiques. Il contient
%donc au maximum 25 tons.
%
%
%Voir aussi GET_PERTINENTS, GET_PERT_DIR, SYNTHETIZE, GET_ALL_FILES.
%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% on recupere les arguments %%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
switch( nargin )
      
    case 1,
      nb   = 20;
      wid  = 4;
      bw   = [.5,1];
      tnmr = 5;
      
    case 2,
      wid  = 4;
      bw   = [.5,1];
      tnmr = 5;
      
    case 3,
      bw   = [.5,1];   
      tnmr = 5;
      
    case 4,
      tnmr = 5;
      if( length(bw)<2 )
         bw = [ bw, 1 ];
      end
      
      
    case 5,
      if( length(bw)<2 )
         bw = [ bw, 1 ];
      end
                 
    otherwise,
      disp('Error, invalid number of arguments.');
      return
      
end%switch( nargin )

if( ~iscell(files) )
   file  = ['mean_pert_',files,'.txt'];
   files = get_all_files(files);
else
   file  = ['mean_pert_',now2str(now),'.txt'];
end%if( ~iscell(files) )


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%% on extrait les composantes %%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
N          = length(files);
[t,noises] = get_pertinents(files{1},nb,bw,tnmr);
%la troisieme colonne de hits contient le nb de 
%fichier ou la frequence a ete trouvee
hits       = [t', ones(length(t(1,:)),1)]';

for( n = 2:N )
   
   [t,nn] = get_pertinents(files{n},nb,bw,tnmr);
   hits   = fusion2(t,hits,wid);
   noises = noises + nn;

   
end%for( n = 2:length(files) )

%trois methode differente pour selectionner
%les tons les plus pertinents, la troisieme
%me semble la plus logique car elle tient compte
%     -de l'amplitude
%     -du nb de fois qu'elle apparait ds les tons pertinents
%     -de la ponderation du au seuil d'audition
%[v,n] = sort(hits(3,:));
%[v,n] = sort(hits(2,:));
[v,n] = sort( hits(2,:) ./ threshold(hits(1,:))' );

n     = fliplr(n);
hits  = hits(:,n);

%il faut bien sur diviser par le nb de 
%fois que le ton apparait, on moyenne
%ainsi l'amplitude.
hits(2,:) = hits(2,:)./hits(3,:);

%on garde les nb premiers tons
if( nb )
   nb = min(nb,length(hits(1,:)));

else
   nb = length(hits(1,:));
end
tones  = hits(1:2,1:nb);
noises = noises/N;

%recherche de la plus grande
%frequence d'echantillonnage
fss = zeros(1,length(files));
for( n = 1:length(files) )
   [dum, fss(n), b]=wavread(files{n});
end
fs = max(fss);
   
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

%si il n'y a pas de sortie, on enregistre 
%les resultats dans un fichier texte
if( ~nargout )
   
   fid = fopen(file,'at');
   fprintf(fid,'Parametres  nb:%d, wid:%f, bw(1):%f, bw(2):%f, tnmr:%f\n\n',nb,wid,bw(1),bw(2),tnmr);
   format long;
   fprintf(fid,'\n\n**************** %s ****************\n',file);
   fprintf(fid,'\n*********       tons :      *********\n');
   for( b=1:N-1 )
      indx = find( ( hits(1,:)>=Barks(b) ) & ( hits(1,:)<Barks(b+1) ) );
      if( length(indx) )
         fprintf(fid,'\n\n * Entre %d et %d Hz :\n',round(Barks(b)),round(Barks(b+1)));
        fprintf(fid,'\nfrequences\tamplitudes\thits\n');
        fprintf(fid,'%6.0f\t\t%1.6e\t%d\n',hits(:,indx));
      end%if( length(indx) )   
   end%for( b=1:25 )
   fprintf(fid,'\n\n* les %d tons les plus pertinents :\n',nb);
   fprintf(fid,'\nfrequences\tamplitudes\thits\n');
   fprintf(fid,'%6.0f\t\t%1.6e\t%d\n',hits(:,1:nb));
   fprintf(fid,'\nDecoupage en bandes de bruit de largeur ',num2str(bw(1)),' bark.');
   for( n=1:N-1 )
	   fprintf(fid,'\nde %5d a %5d Hz :%1.6e',round(Barks(n)),round(Barks(n+1)),noises(n));
	end
   fclose(fid);
   clear noises;
   clear tones;

end%if( ~nargout )

%si le dernier arg 'cbt' de sortie est precise
if( nargout > 2 )
   
   cbt = [];
   row = 1;
   for( b=1:N-1 )
    indx = find( ( hits(1,:)>=Barks(b) ) & ( hits(1,:)<Barks(b+1) ) );
      if( length(indx) )
         cbt(1:2,row) = hits(1:2,min(indx));
         row = row+1;
      end%if( length(indx) )
   end%  for( b=1:25 )
   
end%if( nargout > 2 )

return






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%% Routine locale pour ajouter les nouveaux tons pertinents %%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  out = fusion2( tones, hits, wid )

out = hits;
N   = length(tones(1,:));
M   = length(out(1,:));

%pour chacune des nouvelles frequences
for( n=1:N )
   
   indx = find( abs(tones(1,n)-out(1,:)) <= wid/2 );
   
   if( length(indx) )%si il ya une freq egale
      if( length(indx)>1 )
         mini = min(indx);
         maxi = max(indx);
         out  = [ out(:,1:mini-1), ...
                  [mean(out(1,mini:maxi)),sum(out(2,mini:maxi)),sum(out(3,mini:maxi))]', ...
                  out(:,maxi+1:M) ];
         indx = mini;
         M    = length(out(1,:));
      end
      out(1,indx) = (out(1,indx)+tones(1,n))/2;
      out(2,indx) = out(2,indx)+tones(2,n);
      out(3,indx) = out(3,indx)+1;
      
   else%( length(indx)==0 )
      indx = find( out(1,:) > tones(1,n) );
      if( ~length(indx) )%c'est la plus grande
         out = [ out, [tones(:,n)',1]' ];
      else%il existe des frequ + grandes
         m = min(indx);
         if( m == 1 )%c'est la + petite frequ
            out = [ [tones(:,n)',1]', out ];
         else%ce n'est pas la + petite frequ
            out = [ out(:,1:m-1), [tones(:,n)',1]', out(:,m:M) ];
         end%if( m == 1 )
      end%if( ~length(indx) )
      M = M+1;
      
   end%if( length(indx) )   
   
end%for( n=1:N )
