function [Harms, tones, noises] = mean_pert_harm(files,nb,wid,bw,tnmr)
%
%function [H, T, N] = mean_pert_harm( files [, nb, wid, bw, tnmr ] )
%
%   On passe une cell de fichier wav 'files' senses representes 
%le meme son, on extrait alors les tons pertinents grace a
%MEAN_PERTINENTS, et sur chacune des frequences ainsi trouvees
%on applique MEAN_HARMONICS. On recupere ainsi une cell 'H' 
%de sequence harmoniques dont la fondamentale ou la premiere
%harmonique est consideree commme pertinente. 'T' est le
%tableau des tons pertinents avec leur amplitude, 'N' est le 
%tableau des niveaux des 25 bandes de bruit de largeur 1 bark.
%   Si aucun arguments n'est precise en sortie, les resultats
%seront enregistres dans un fichier texte nomme 'mean_pert_harms'
%suivi de la date et de l'heure de creation.
%
%
%REMARQUE, cette fonction est a prefere a MEAN_PERTINENTS car elle
%          effectue le meme traitement plus la recherche des sequences
%          harmoniques jugees pertinentes.
%
%Voir aussi MEAN_PERTINENTS, MEAN_HARMONICS, GET_PERT_HARM.
%
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
   
	case 5,
   
	otherwise,
   disp('Error, invalid number of arguments.')
   return
      
end%switch

if( ~iscell(files) )
   name  = ['mean_pert_harm_',files];
   files =get_all_files(files);
else
   name  = ['mean_pert_harm_',now2str(now)];
end%if( ~iscell(files) )

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Le traitement se fait ici ...  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[tones, noises] = mean_pertinents(files,nb,wid,bw,tnmr);  %
frequ = get_funds(tones(1,:),wid);                        %
Harms = mean_harmonics(files,frequ,wid);                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if( ~nargout )
   fid  = fopen([name,'.txt'],'at');
   fprintf(fid,'Resultat de mean_pert_harm, %s...\n\n',name);
	fprintf(fid,'Parametres  nb:%d, wid:%f, bw(1):%f, bw(2):%f, tnmr:%f\n\n',nb,wid,bw(1),bw(2),tnmr);
   tones2file(tones,fid);
   cell2file( Harms,fid, ...
      		  ['Sequences harmoniques dont les fondamentales sont des frequences pertinentes...'], ...
      		  	3 );
   fprintf(fid,'\n\n');
   noises2file( noises, fid, ...
                ['Bruit par bande de largeur ',num2str(bw(2)),' bark.'] );
   fclose(fid);
   clear Harms;
   clear tones;
   clear noises;
end%if( ~nargout )
