function Texture = Decompress( Modele, Proj )
%
%function Texture = Decompress( Modele, Proj )
%
%Permet de decompresser une texture compressee par Compress.
%
%
[n,n,Nb]=size(Proj);
[VectP,ValP]=KLBase(im2Noyau(Modele));
[Taille,Taille]=size(Modele);
Texture=zeros(n*Taille,n*Taille);

for(i=0:n-1)
   for(j=0:n-1)
      imagette=zeros(Taille,Taille);
      for(k=1:Nb)
         imagette=imagette+Proj(i+1,j+1,k)*Vect2Mat(VectP,k);
      end%for_k      
      Texture(i*Taille+1:(i+1)*Taille,j*Taille+1:(j+1)*Taille)=imagette;
    end%for_j
end%for_i


