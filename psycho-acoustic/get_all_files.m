function noms = get_all_files(str)
%
%function noms = get_all_files( str )
%
%   'noms' est un tableau de cellules contenant tous les noms de
%fichiers wave du repertoire courant contenant la chaine 'str'.
%
%
%Voir aussi CUT_WAVFILE, GET_ALL_DIR.
%
LS = length(str);
if( LS > 4 )
   if( strcmp(str(LS-3:LS),'.wav') | ...
       strcmp(str(LS-3:LS),'.WAV') )
      str = str(1:LS-4);
   end
end      
command	= ['names=dir(''*',str,'*.wav'');'];
eval(command);
noms	= cat(1,{names(:).name})';