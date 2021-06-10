%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%demo%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

fprintf('\n')
disp('   GENESE DE TEXTURE')
fprintf('\n')

bruit=randn(264,264);

titre_M='Masque de Laplace : a=';
titre_T='Texture de BP(-10dB) normalisee c=';
disp('Voici un premier masque de Laplace...')
masque1=MLaplace(11,1,1,0);
figure(1)
colormap(hot)
imagesc(masque1)
colorbar('vert')
title(strcat(titre_M,num2str(1),', b=',num2str(1),', r=',num2str(0)))
input('taper sur entree pour continuer');

disp('Si on filtre un bruit gaussien centre reduit')
disp('avec ce masque on obtient la texture...')
texture1=filter2(masque1,bruit);
figure(2)
colormap(hot)
imagesc(texture1)
colorbar('vert')
%title( strcat( titre_T, num2str(BandePas(texture1,0.1)) ) )
input('taper sur entree pour continuer');

disp('On fait evoluer r de 3 a 21 en gardant a et b constants')
disp('Les textures evoluent de la maniere suivante:')
for(i=1:15)
   masque1=MLaplace(11,-i,1/i,i+1);
   texture1=filter2(masque1,bruit);
   figure(2)
   colormap(hot)
   plot(SpectreP(texture1))
   figure(3)
   imagesc(masque1)
   colorbar('vert')
   %title( strcat( titre_T, num2str(BandePas(texture1,0.1)) ) )
   pause(1);
end%for_i

