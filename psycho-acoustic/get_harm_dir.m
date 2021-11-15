function get_harm_dir(directory,F0,wid,thr)
%
%function get_harm_dir( directory [, F0, wid, thr ] )
%
%   Applique la fonction GET_HARMONICS a tous les fichiers wav
%contenus dans le repertoire 'directory'. Attention, a ne lancer
%que le soir avant de partir si le repertoire contient plus d'une
%dizaine de fichiers.
%
%
%REMARQUE, il arrive souvent que le traitement se bloque.
%
%Voir aussi GET_HARMONICS, MEAN_HARMONICS.
%

Fmin = 40;
Fmax = 11025;

switch( nargin )
   
	case 1,
   F0    = [Fmin, Fmax];
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

warning off;

indir=pwd;
cd(directory);
nom = get_all_files('*');
tic;

for( n=1:length(nom) )
   get_harmonics(nom{n},F0,wid,thr);
end

t=toc;
h = sec2hour(t);
disp([num2str(length(nom)), ' fichier(s) traite(s) en ', h, '.'])
cd(indir);
warning on;

