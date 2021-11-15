function [ Harms, tones, noises ] = get_pert_harm( file, nb, wid, bw )
%
%function [ Harms, noises ] = get_pert_harm( file [, nb, wid, bw ] )
%
%   Recherche des composantes tonales pertinentes presentes
%dans le fichier wave 'file', puis recherche les sequences 
%harmoniques correspondantes. 'nb' est le nombre de composantes
%tonales a garder (20, par defaut), wid est la difference maximum
%entre deux frequences considerees comme egales par l'algorithme
%(2 Hz par defaut), et 'bw' est la largeur des fenetres utilisees
%pour le masquage frequentiel (et eventuellemnt si c'est un tableau
%de 2 cases pour le decoupage en bande de bruit).
%
%
%Voir aussi GET_PERTINENTS, GET_HARMONICS, MEAN_PERT_HARM.
%
switch( nargin )
   
   case 1,
   nb  = 20;
   wid = 2;
   bw  = [.5, 1];
   
   case 2,
   wid = 2;
   bw  = [.5, 1];
   
   case 3,
   bw  = [.5, 1];
   
	case 4,
   if( length(bw)==1 )
      bw = [bw, 1];
   end   
   
   otherwise,
   disp('Error, invalid number of arguments.')
   return
      
end%switch

%extraction des composantes pertinantes du son
[tones, noises] = get_pertinents(file,nb,bw);

%on ne recupere que les frequences fondamentales
frequ = get_funds( tones(1,:), wid );

%on recherche les sequences harmoniques
if( length(frequ)~=2 )
   Harms = get_harmonics(file,frequ,wid);
else
   Harms = [ get_harmonics(file,frequ(1),wid), ...
             get_harmonics(file,frequ(2),wid) ];
end

%sauvegarde dans un fichier texte
if( ~nargout )
   name = ['pert_harm_',file];
   fid  = fopen([name,'.txt'],'at');
   fprintf(fid,'Resultat de get_pert_harm, %s...\n\n',name);
   fprintf(fid,'Parametres  nb:%d, wid:%f, bw(1):%f, bw(2):%f.\n\n',nb,wid,bw(1),bw(2));
   tones2file(tones,fid);
   cell2file( Harms,fid, ...
              ['Sequences harmoniques dont les fondamentales sont des frequences pertinentes...'], ...
              3 );
              
   fprintf(fid,'\n');
   noises2file( noises, fid, ...
      			 ['Bandes de bruit de largeur ', num2str(bw(2)),' bark.'] );
   fclose(fid);
   clear Harms;
   clear tones;
   clear noises;
end
