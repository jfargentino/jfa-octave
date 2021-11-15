function H = mean_harmonics( files, F0, wid, thr )
%
%function H = mean_harmonics( files, F0 )
%function H = mean_harmonics( files [, F0, wid, thr ] )
%function H = mean_harmonics( str, F0 )
%function H = mean_harmonics( str [, F0, wid, thr ] )
%
%   On donne un tableau de cellules de noms de fichiers wav 'files' senses
%representer le meme son, ou une chaine de caracteres contenue dans tous les
%noms des que l'on desire analyser. Alors on moyenne toutes les sequences
%trouvees pour n'en faire qu'une seule, permettant de moyenner de maniere
%automatique. Cette fonction prend les memes arguments d'entree que
%GET_HARLMONICS.
%
%
%function mean_harmonics( ... )
%
%   Si aucun arguments de sortie n'est precise, on sauvegarde les 
%resutltats dans un fichier texte du repertoire courant. Le nom du 
%fichier est 'mean_har' suivi de la date et de l'heure.
%
%
%Voir aussi GET_HARMONICS, GET_HARM_DIR, GET_ALL_FILES.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fmin = 40; Fmax = 11025;                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch( nargin )
   
   case 1,
   F0 = [Fmin, Fmax];
   wid   = 4;
   thr   = 5e-4;

   case 2,
   wid   = 4;   
   thr   = 5e-4;
      
   case 3,
   thr   = 5e-4;
      
   case 4,
                   
   otherwise,
   disp('Error, invalid number of arguments.')
   return   
   
end%switch( nargin )

if( ~iscell(files) )
   file  = ['mean_harm_',files];
   files = get_all_files(files);
else
   file  = ['mean_harm_',now2str(now)];
end%if( ~iscell(files) )

H  = get_harmonics(files{1},F0,wid);
LH = length(H);

for( n = 2:length(files) ) 
   h = get_harmonics(files{n},F0,wid);
   H = cell_fusion(h,H,wid);
end%for( n = 1:length(files) )

if( ~nargout )
    header = ['recherche des suites harmoniques, tolerances ', num2str(wid),'.'];
    cell2file(H,file,header,2)   
    clear H;
end
