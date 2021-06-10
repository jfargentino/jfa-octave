function BP = BandePas(Texture,Seuil)
%
%function BP = BandePas(Texture,Seuil)
%
%Texture : une matrice N*N;
%
%Seuil   : un chiffre entre 0 et 1
%          par exemple 0.1 correspond
%          a la bande passante -10dB;
%
% BP     : la frequence numerique de 
%          coupure, correspond a la 
%          valeur 2Fc/Fe ou Fc la freq
%          de coupure, Fe la freq d'ech.
%
%          
dsp=SpectreP(Texture);
[n,N]=size(dsp);
if((Seuil<=0)|(Seuil>=1))
   Seuil=0.1;
end%if
i=N;
while( dsp(i)<Seuil )
   i=i-1;
end%while
[N,N]=size(Texture);
BP=i/N;