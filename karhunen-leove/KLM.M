function [Proj,VectP,ValP] = KLM( Image , Noyau )
%
%function [Proj VectP ValP] = KLM( Image )
%
%Image   :  une matrice carre a developpée
%
%Noyau   :  'ettale' du tenseur modeliseant
%           la 'matrice' de variance-covariance
%           du processus Image
%
%Proj    :  coefficients de la decomposition
%           de Image sur la base VectP
%
%VectP   :  vecteurs propres du noyau
%           base de la decomposition
%           ils sont en colonnes
%
%Valp    :  valeurs propres du noyau
%
%Les val. et vect. propres sont classes par
%ordre decroissant de val. propres.
%
%

[ N,N ] = size(Image);
if(~mod(N,2))
   N=N-1;
end

%determination des 
%val. propres / vect. propres
[VectP,ValP] = KLbase(Noyau);

N2=N*N;

%projection de l'image sur
%chacun des vecteurs de la base
vimage=zeros(1,N2);
vimage(:)=Image';
Proj=zeros(N2,1);
for(i=1:N2)
     Proj(i)=Proj(i)+vimage*VectP(:,i);
end


