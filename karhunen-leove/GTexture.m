function Texture = GTexture(Taille,Param)
%
%function Texture = GTexture(Taille,Param)
%
%Taille : taille de la texture generee
%
%Param : si Param est un nombre n, le masque est
%        la matrice identite n*n;
%        si Param est un vecteur [n,a], le 
%        masque est une matrice n*n remplie de a;
%        si Param est un vecteur [n,a,b,r], le 
%        masque est une matrice Laplacienne.
%        si Param est une matrice, elle servira
%        directement de masque.
%
%Texture est une matrice carre Taille*Taille
%
%

switch( nargin )
   
case 0,
   Taille = 512;
   Param  = [ 32, 1, 1, 0 ];
   
case 1,
   Param  = [ 32, 1, 1, 0 ];
   
case 2, 
   
otherwise, 
   disp( 'Nb d''arguments invalide.' );
   return;
   
end


[np,mp]=size(Param);

if( (np>1)&(mp>1) )
   masque=Param;
end%if

if( (np==1)&(mp==1) )
   masque=eye(Param);
end%if

if( (np==1)&(mp==2) )
   masque=Param(2)*ones(Param(1),Param(1));
end%if

if( (np==1)&(mp==4) )
   masque=MLaplace(Param(1),Param(2),Param(3),Param(4));
end%if

Texture=filter2(masque,randn(Taille,Taille));

if( ~nargout )
   figure;
   imagesc( Texture );
   colormap( 'hot' );
   grid on;
   colorbar;
   clear Texture;
end
