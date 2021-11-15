function tones2file(tones,file)
%
%function tones2file( tones, file )
%
%   Sauvegarde du tabeau de frequences/amplitudes
%'tones' dans le fichier nomme 'file'. Si ce dernier
%n'existe pas il est cree, sinon ou ecrit a sa suite.
%
%
%function tones2file( tones, fid )
%
%   On peut eventuellement preciser le fichier grace
%son identifiant 'fid', alors le fichier doit ouvert
%et ferme en dehors de cette fonction.
%
%
%Voir aussi CELL2FILE, NOISES2FILE.
%
if( ischar(file) )
	if( (strcmp(file(length(file)-3:length(file)),'.wav')) |...
    	 (strcmp(file(length(file)-3:length(file)),'.txt'))     )
   	file=file(1:length(file)-4);
	end
   fid = fopen([file, '.txt'],'at');
else
   fid = file;
end%if( ischar(file) )

format long;
fprintf(fid,'\n*********     %d tons :     *********\n',length(tones(1,:)));
fprintf(fid,'\nfrequences\tamplitudes\n');
fprintf(fid,'%6.0f\t\t%1.6e\n',tones);

if( ischar(file) )
	fclose(fid);
end