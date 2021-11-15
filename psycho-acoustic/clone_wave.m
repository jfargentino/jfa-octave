function clone_wave(wavfile, adjust, nb, wid, bw, tnmr)
%
%fonction clone_wave( wavfile [, adjust, nb, wid, bw, tnmr] )
%
%   Permet de synthtetiser le fichier wave 'wavfile' grace
%a la methode developpee. Le nom du fichier ainsi cree se
%deduit de 'wavfile' en ajoutant le prefixe 'SYNTH_'. Le
%fichier synthetise aura la meme duree et le meme niveau
%que le signal original.
%   Les arguments 'nb', 'wid', 'bw' et 'tnmr' sont les
%arguments passes a la fonction MEAN_PERTINENTS.
%
%
%fonction clone_wave( cellfiles [, adjust, nb, wid, bw, tnmr] )
%
%   On peut egalement passer une cellule contenant les noms
%des fichiers wave a cloner.
%
%Voir aussi MEAN_PERTINENTS, SYNTHETIZE.
%

switch( nargin )
      
    case 1,
      adjust = 1;
      nb   = 20;
      wid  = 4;
      bw   = [.5, 1];
      tnmr = 5;
      
    case 2,
      nb   = 20;
      wid  = 4;
      bw   = [.5, 1];
      tnmr = 5;
      
   case 3,
      wid  = 4;
      bw   = [.5, 1];
      tnmr = 5;
      
   case 4,
      bw   = [.5, 1];
      tnmr = 5;
         
    case 5,
       tnmr = 5;
       
    case 6,
       
    otherwise,
      disp('Error, invalid number of arguments.');
      return
      
end%switch( nargin )

!mkdir TMP

if( ~iscell(wavfile) )
   wavfile = {wavfile};
end

for( f=1:length(wavfile) )
   
   cut_wavfile(wavfile{f},'TMP');
   [s, fs, b] = wavread( wavfile{f} );
   [N, V] = size( s );
   cd TMP;
   
   if( V == 1 )%son mono
      [t, n] = mean_pertinents(wavfile{f}, nb, wid, bw, tnmr);
      [s, fs, b] = synthetize(t,n,adjust,fs,N/fs);
      disp(['nombre de tons: ', num2str(length(t(1,:))),'.'])
   else%( V == 2 ) son stereo
   	[t1, n1] = mean_pertinents('voie1', nb, wid, bw, tnmr);
      [s(:,1), fs, b] = synthetize(t1,n1,adjust,fs,N/fs);
      disp(['nombre de tons a droite: ', num2str(length(t1(1,:))),','])
		[t2, n2] = mean_pertinents('voie2', nb, wid, bw, tnmr);
      [s(:,2), fs, b] = synthetize(t2,n2,adjust,fs,N/fs);
      disp(['nombre de tons a gauche: ', num2str(length(t2(1,:))),'.'])      
   end%if( V == 1 )
   !deltree /Y *   
   cd ..;

   wavwrite(s,fs,b,['SYNTH_',wavfile{f}]);
   
end

!deltree /Y TMP
