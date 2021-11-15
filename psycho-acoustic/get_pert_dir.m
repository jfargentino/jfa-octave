function get_pert_dir( directory, nb, bw, tnmr )
%
%function get_pert_dir( directory [, nb, bw, tnmr] )
%
%   Applique la fonction GET_PERTINENTS a tous les fichiers 
%wav contenus dans dans le repertoire 'directory'.
%
%
%Voir aussi GET_PERTINENTS, MEAN_PERTINENTS.
%

switch( nargin )
      
   	case 1,
      nb   = 20;
      bw   = [.5, 1];
      tnmr = 5; 
      
      case 2,
      bw   = [.5, 1];
      tnmr = 5;
      
   	case 3,
      tnmr = 5;
         
   	case 4,
            
   	otherwise,
      disp('Error, invalid number of arguments.');
      return
      
end%switcn( nargin )

warning off;

indir=pwd;
cd(directory);
nom = get_all_files('*');
tic;

for( n=1:length(nom) )
   get_pertinents(nom{n}, nb , bw, tnmr);
end

t=toc;
h = sec2hour(t);
disp([num2str(length(nom)), ' fichier(s) traite(s) en ', h, '.'])
cd(indir);
warning on;
