
function analyse_harm( directory, F0, wid, thr, len, nf )
%
%function analyse_harm( directory [, F0, wid, thr, len, nf ] )
%
%   Le repertoire 'directory' doit contenir les fichiers
%au format wav a analyser. Dans un premier temps, le
%repertoire sera prepare grace a PREPARE_DIR, sauf si le 
%sous-repertoire 'PREPARED' existe deja. Puis pour chacun 
%des sons ainsi formates, on applique MEAN_HARMONICS.
%   Les arguments 'F0', 'wid', 'thr' ont le meme role 
%que pour MEAN_HARMONICS. Enfin les arguments 'len' et 'nf'
%precisent respectivement la taille des fichiers d'analyse
%et si on normalise le niveau ('nf'=1) ou pas ('nf'=0 qui
%est la valeur par defaut). Ce sont les arguments qui sont
%passes a PREPARE_DIR.
%
%
%ATTENTION, traitement a ne lancer que le soir avant de partir.
%
%Voir aussi PREPARE_DIR, MEAN_HARMONICS, ANALYSE_PERT,
%           ANALYSE_PERT_HARM.
%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Fmin = 40; Fmax = 11025;                                             %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

switch( nargin )
   
	case 1,
   F0  = [Fmin, Fmax];
   wid = 4;
   thr = 5e-4;
   len = 32768;
   nf  = 0;  
   
	case 2,
	wid = 4;
   thr = 5e-4;
   len = 32768;
   nf  = 0;
   
   case 3,
   thr = 5e-4;
   len = 32768;   
   nf  = 0;
   
	case 4,
   len = 32768;      
   nf  = 0;
   
	case 5,
   nf  = 0;
      
	case 6,
   
	otherwise,
   disp('Error, invalid number of arguments.')
   return   
   
end%switch( nargin )

indir = pwd;
cd(directory)

%esque le repertoire est deja pres pour l'analyse?
if(~length(dir('PREPARED')))
   disp('Preparation du repertoire pour l''analyse')
   prepare_dir(directory, len, nf);
end   

cd('PREPARED');

%on recupere tous les sous repertoires
subdir = get_all_dir('.');
N      = length(subdir);

%si il n'y a pas de sous repertoire on sort
if( ~N )
   return
end

tic
%traitement dans chacun des sous repertoires
for( n=1:N )
   cd(subdir{n});
   mean_harmonics(get_all_files(subdir{n}),F0,wid,thr);
   cd('..');
end%for
t=toc;

disp([num2str(N),' dossier(s) traite(s) en ',sec2hour(t),'.'])
cd(indir)
