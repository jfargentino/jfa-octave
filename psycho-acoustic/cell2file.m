function cell2file( C, file, header, nb_min )
%
%function cell2file( C, file [, nb_min ] )
%function cell2file( C, file [, header, nb_min ] )
%
%   Enregistre de la maniere la plus lisible un tableau de cellules
%'C' dans un fichier texte 'file'. 'C' est typiquement la sortie de
%GET_HARMONICS ou MEAN_SEQUENCES... Si 'file' existe deja, la
%sauvegarde se fait a la suite du fichier.
%   On peut egalement specifier une entete 'header' qui sera
%ecrite dans le fichier juste avant les donnees proprement dites,
%par defaut le commentaire sera le nom du fichier.
%   Pour ameliorer la lecture, on peut ne sauvegarder que les
%sequences contenant un minimum de 'nb_min' harmoniques, celui-ci
%etant a 1 si il n'est pas precise.
%
%
%function cell2file( C, fid [, nb_min ] )
%function cell2file( C, fid [, header, nb_min ] )
%
%   On peut egalement preciser le fichier ou faire la sauvegarde
%par son identifiant 'fid'. Il devra alors deja etre ouvert lors
%de l'appel de la fonction, et sa fermeture est a la charge de
%l'utilisateur.
%
%
%Voir aussi GET_HARMONICS, MEAN_HARMONICS, NOISES2FILE, TONES2FILE.
%

switch( nargin )
   
case 2,
   header  = file;
   nb_min  = 1;
      
case 3,
   if( ischar(header) )
   	nb_min  = 1;
   else
      nb_min  = header;
      header  = file;
   end
         
case 4,
   if( ischar(header) )
   else
      disp('Error, invalid number of argument.')
   end
   
otherwise,
   disp('Error, invalid number of argument.')
   return   
      
end%switch( nargin )

%ouverture du fichier
if( ischar(file) )
	if( (strcmp(file(length(file)-3:length(file)),'.wav')) |...
    	 (strcmp(file(length(file)-3:length(file)),'.txt'))     )
   	file=file(1:length(file)-4);
	end
   fid = fopen([file, '.txt'],'at');
else
   fid = file;
end%if( ischar(file) )

fprintf(fid,'\n\n%s\n\n\n\n',header);

warning off;

for( n=1:length(C) )
	if( length( C{n}(1,:) ) >= nb_min )
%		if( round( C{n}(1,2)/C{n}(1,1) ) <= dif_max )
		  	fprintf(fid,'**************** frequence %6.3e Hz ****************\n\n',C{n}(1,1));
         fprintf(fid,'\t n°  :   frequence  :     niveau     :    dB\n');
         if( C{n}(2,1) )
            fprintf(fid,'\t%3d  : ( %9.3f  : %.6e  : %6.3f\t)\n',[round(C{n}(1,:)'/C{n}(1,1)),C{n}',20*log10(C{n}(2,:)'/C{n}(2,1))]');
         else%( C{n}(2,1) == 0 )
            fprintf(fid,'\t%3d  : ( %9.3f  : %.6e  : %6.3f\t)\n',[round(C{n}(1,:)'/C{n}(1,1)),C{n}',20*log10(C{n}(2,:)'/C{n}(2,2))]');
			end%if( C{n}(2,1) )
	      fprintf(fid,'\n*********************************************************\n\n\n\n');
%      end% if( round( Harm{n}(2,1)/Harm{n}(1,1) ) <= dif_max )
  	end%if( length( Harm{n}(:,1) ) >= nb_min )   
end%for( n=1:length(C) )
      
warning on;

if( ischar(file) )
   fclose(fid);
end
