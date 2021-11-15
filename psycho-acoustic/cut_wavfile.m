function cut_wavfile(wavfile,dirout,N,nf)
%
%function cut_wavfile( wavfile [, dirout, len, nf ] )
%
%   Coupe le fichier 'wavfile' en plusieurs fichiers
%de 'len' echantillons (32768) et les enregistre dans le 
%repertoire 'dirout', si ce dernier n'est pas precise
%dans le repertoire courant. Enfin l'argument 'nf permet
%de preciser si on veut normaliser en amplitude les 
%fichiers ('nf'~=0) ou pas ('nf'==0, valeur par defaut).
%
%
%Voir aussi PREPARE_DIR.
%

warning off;

if( ~( (strcmp(wavfile(length(wavfile)-3:length(wavfile)),'.wav')) | ...
       (strcmp(wavfile(length(wavfile)-3:length(wavfile)),'.WAV')) ) )
	wavfile=[wavfile,'.wav'];
end

switch( nargin )
   
	case 1,
   dirout = '.';
   N = 32768;
   nf = 0;
   
	case 2,
   N = 32768;
   nf = 0;
   
	case 3,
   nf = 0;
   
	case 4,
   
	otherwise,
   disp('Error, bad number of argument.')
   return
   
end%switch( nargin )

if( nargin==1 )
   dirout='.';
end%if( nargin==1 )

%lecture du fichier
[s fs b] = wavread(wavfile);

%taille et nb de voies
[L V]    = size(s);

%pour chacune des voies
for( v = 1:V )
	   
   if( floor(L/N) <= 1 )
      if( nf )
         ss = s(:,v)/max(abs(s(:,v)));
      else
         ss = s(:,v);
      end%if( nf )
      if( V > 1 )
         wavwrite(ss,fs,b,[dirout,'\voie',num2str(v),'_',wavfile]);
      else%( v==1 )
         wavwrite(ss,fs,b,[dirout,'\P_',wavfile]);
      end% if( v > 1 )
      
   else%( floor(L/N) > 1 )
      for( n = 0:floor(L/N)-1 )
         if( nf )
            ss = s(n*N+1:(n+1)*N,v)/max(abs(s(n*N+1:(n+1)*N,v)));
         else%( nf== 0 )
            ss = s(n*N+1:(n+1)*N,v);
         end%if( nf )
         if( V > 1 )
	         wavwrite(ss,fs,b,[dirout,'\voie',num2str(v),'_',num2str(n),'_',wavfile]);
   		else%( v==1 )
         	wavwrite(ss,fs,b,[dirout,'\',num2str(n),'_',wavfile]);
      	end% if( v > 1 )
      end%for( n = 1:floor(L/N) )
   end%if( floor(L/N) <= 1 )
   
end%for( v = 1:V )

warning off;