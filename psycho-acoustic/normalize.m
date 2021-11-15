function out = normalize( in )
%
%function out = normalize( in )
%
%   Normalisation du signal 'in' en energie,
%c'est a dire que 'out' = A * 'in' avec :
%
%                   ______________________
%         \        /         __N_         |
%          \      /       /  \
%    A  =   \    /   N   /    >  s(n)² 
%            \  /       /    /___
%             \/             n = 1
%
%ou N et les s(n) sont respectivement la taille et les
%elements du signal 'in'.
%

out = sqrt( length(in) / sum( in .^ 2 ) ) * in;

%la meme chose, plus lisible mais moins rapide...
%s1 = sum( in .^ 2 );
%out = sqrt( length(in) / s1 ) * in;

