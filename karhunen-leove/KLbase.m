function [ VectP,ValP ] = KLbase( Noyau )

%
%[ VectP ValP ] = function KLbase( Noyau )
%
%Noyau : la sortie de GNoyau(Image) ou un modele
%        de noyau pour Image
%
%   Retourne la matrice VectP des vecteurs propres du noyau 
%ainsi que le vecteur ValP des valeurs propres correspondantes.
%Ainsi VectP(:,i) correspond à la valeur propre ValP(i).
%ValP est trié dans l'ordre décroissant.
%

%on determine valeur propre et vecteur propre
[ vec0 , val0 ] = eig(Noyau);
ValP = diag(val0);
%on classe les val propres par ordre decroissant
[ ValP , index ] = sort(ValP);
ValP=ValP(end:-1:1);
index=index(end:-1:1);
%on classe les vec propres par val decroissantes
[ n , n ] = size(Noyau);
for(j=1:n)
	VectP(:,j)=vec0(:,index(j));
end%for

