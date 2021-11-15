function prepare_dir(directory,len,nf)
%
%function prepare_dir( directory [, len, nf ] )
%
%   Prepare tout les fichiers wav contenus dans
%le repertoire 'directory' et enregistre les
%fichiers ainsi traites dans un sous-repertoire
%nomme 'PREPARED'.
%
%
%Voir aussi CUT_WAVFILE, GET_ALL_FILES.
%

warning off;

switch( nargin )
   case 1,
   len = 32768;
   nf  = 0;
   
	case 2,
   nf  = 0;
     
	case 3,
   
	otherwise,
   directory = '.';   
   len = 32768;
   nf  = 0;

end%if

indir=pwd;

cd(directory);

!mkdir PREPARED

command	= 'names=dir(''*.wav'');';
eval(command);
nom	= cat(1,{names(:).name})';

for(n=1:length(nom))
   
   str_dir = ['PREPARED\', nom{n}(1:length(nom{n})-4)];
   eval( ['!mkdir ', str_dir] );
   cut_wavfile(nom{n},str_dir,len,nf);   
   
end%for(n=1:length(nom))

cd(indir);

warning on;   