function noises2file(noises,file,header)
%
%function noises2file( noises, file [, header ] )
%
%   Sauvegarde du tableau des niveaux de bande de bruit
%'noises' dans le fichier de nom 'file'. Si le fichier
%n'existe pas on le cree, sinon on ecrit a la fin.
%Le fichier est ouvert et ferme dans la fonction.
%
%
%function noises2file( noises, fid [, header ] )
%
%   On peut acceder au fichier par son identifiant 'fid',
%cela suppose alors qu'il est deja ouvert. De plus la
%fonction ne le fermera pas.
%
%
%Voir aussi TONES2FILE, CELL2FILE.
%
if( nargin < 3 )
   header = ['Decoupage en ', num2str(length(noises)), ' bandes de bruits.'];
end

if( ischar(file) )
	if( (strcmp(file(length(file)-3:length(file)),'.wav')) |...
    	 (strcmp(file(length(file)-3:length(file)),'.txt'))     )
   	file=file(1:length(file)-4);
	end
   fid = fopen([file, '.txt'],'at');
else
   fid = file;
end%if( ischar(file) )

N      = length( noises );
Barks  = [ bark2hz(0:25/N:25-25/N), 22050 ];
Barks(1) = 20;

format long;
fprintf(fid,'\n%s\n',header);
fprintf(fid,'\n********* bandes de bruits: *********\n');
for( n=1:N )
   fprintf(fid,'\nde %5d a %5d Hz :%1.6e',round(Barks(n)),round(Barks(n+1)),noises(n));
end

if( ischar(file) )
	fclose(fid);
end