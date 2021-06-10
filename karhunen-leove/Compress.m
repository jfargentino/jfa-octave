function [ Modele, Proj ] = Compress( Texture, Taille, Nb)
%
%function [ Modele, Proj ] = Compress( Texture, Taille, Nb)
%
%   Compress permet de compresser une texture (un processus aleatoire 2D
%le plus stationnaire possible) grace a la decomposition de Karhunen-Loeve.
%Pour une Texture de N*N pixels, on ne garde que Taille²+Nb*(N/Taille)² 
%unites d'informations. Par exemple pour N=264, Taille=11 et Nb=50, on 
%passe de 69696 à 121+50*576=28921 soit un rapport de compression de 2,41.
%
%Texture: une matrice representant un processus le plus stationnaire possible.
%
%Taille : taille des imagettes que l'on va prelever de la texture, si N est 
%         la taille de la texture, on sortira donc (N/Taille)² imagettes.
%
%Nb     : en supposeant le processus stationnaire, on genere les Taille
%         imagettes de la base de KL, notre but etant la compression, on ne
%         gardera que Nb projections de chacunes des imagettes extraite de la
%         texture sur les imagettes de la base de KL.
%
%Modele : la texture etant consideree comme stationnaire, une imagette de taille
%         Taille suffit à decrire le processus.
%
%Proj   : tableau de (N/Taille)*(N/Taille)*Nb, Proj(i,j,k) representant la 
%         projection de l'imagette(i,j) sur le k-ieme vecteur de la base de KL.
%
%
[N,M]=size(Texture);
if(N~=M)
   N=min(N,M);
end%if
if(~mod(Taille,2))
   Taille=Taille-1;
end%if
if(Taille>N)
   Taille=N;
end%if
if(Nb>Taille*Taille)
   Nb=Taille*Taille;
end%if

n=round(N/Taille);
Modele=zeros(Taille,Taille);
imagette=zeros(Taille,Taille);
Proj=zeros(n,n,Nb);

milieu=round(n/2)*Taille+1;
Modele(:,:) = Texture(milieu:milieu+Taille-1,milieu:milieu+Taille-1);
noyau=im2noyau(Modele);
[VectP,ValP]=KLBase(noyau);

for(i=0:n-1)
   for(j=0:n-1)
      imagette(:,:) = Texture(i*Taille+1:(i+1)*Taille,j*Taille+1:(j+1)*Taille);
      vimage=zeros(1,Taille*Taille);
      vimage(:)=imagette';
      for(k=1:Nb)
         Proj(i+1,j+1,k)=vimage*VectP(:,k);
      end%for_k      
   end%for_j
end%for_i
