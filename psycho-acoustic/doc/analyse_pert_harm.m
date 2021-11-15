function analyse_pert_harm( directory, nb, wid, bw, tnmr, len, nf )
%
%function analyse_pert_harm( directory [, nb, wid, bw, tnmr, len, nf ] )
%
%   Le repertoire 'directory' doit contenir les fichiers
%au format wav a analyser. Dans un premier temps, le
%repertoire sera prepare grace a PREPARE_DIR, sauf si le 
%sous-repertoire 'PREPARED' existe deja. Puis pour chacun 
%des sons ainsi formates, on applique MEAN_PERT_HARM.
%   Les arguments 'nb', 'wid', 'bw' ont le meme role que 
%pour MEAN_PERT_HARM. Enfin les arguments 'len' et 'nf'
%precisent respectivement la taille des fichiers d'analyse
%et si on normalise le niveau ('nf'=1) ou pas ('nf'=0 qui
%est la valeur par defaut). Ce sont les arguments qui sont
%passes a PREPARE_DIR.
%
%
%ATTENTION, traitement a ne lancer que le soir avant de partir.
%
%Voir aussi PREPARE_DIR, MEAN_PERT_HARM, ANALYSE_PERT,
%           ANALYSE_HARM.
%

switch( nargin )
   
	case 1,
   nb   = 20;
   wid  = 4;
   bw   = [.5, 1];
   tnmr = 5;
   len  = 32768;
   nf   = 0;
   
	case 2,
	wid  = 4;
   bw   = [.5, 1];
   tnmr = 5;
   len  = 32768;
   nf   = 0;
   
   case 3,
   bw   = [.5, 1];
   tnmr = 5;
   len  = 32768;
   nf   = 0;
   
	case 4,
   tnmr = 5;
   len = 32768;
   nf  = 0;
   
	case 5,
   len = 32768;   
   nf  = 0;
   
	case 6,
   nf  = 0;
   
	case 7,
   
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

subdir = get_all_dir('.');
N      = length(subdir);

if( ~N )
   return
end


tic
for( n=1:N )
   disp(subdir{n})
   cd(subdir{n});
   mean_pert_harm(get_all_files(subdir{n}),nb,wid,bw,tnmr);
   cd('..');
end%for
t=toc;

disp([num2str(N),' dossier(s) traite(s) en ',sec2hour(t),'.'])
cd(indir)
