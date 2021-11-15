function out = cell_sort( in )
%
%fonction cout = cell_sort( cin )
%
%   Permet le trie du tableau de cellules 'cin', la cellule
%'cout' sera donc classee par fondamentales croissantes.
%
%Voir aussi CELL_FUSION, MEAN_HARMONICS.
%

L   = length( in );
out = cell( L );
tmp = zeros(L,1);
for( l = 1:L )
   tmp(l) = in{l}(1,1);
end
[tmp,indx] = sort(tmp);
out = {in{indx}};



