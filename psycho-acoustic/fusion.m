function  out = fusion( in1, in2 )
%
%fonction  array_out = fusion( array_in1, array_in2 )
%
%   Fusionne les deux tableaux pour n'en faire qu'un.
%Les deux tableaux sont senses representer deux
%sequences harmoniques de meme fondamentale.
%
%
%Voir aussi CELL_FUSION, INSERTION.
%
tmp    = [in1, in2];
[u, v] = sort(tmp(1,:));
tmp    = tmp(:,v);
N      = length(tmp(1,:));
out    = [];
n      = 1;
m      = 1;
while( n <= N )
   p = n;
   while( ( n<N )&( round((tmp(1,n+1)-tmp(1,n))/tmp(1,1)) == 0 ) )
   %while( ( n<N )&( abs(tmp(1,n)-tmp(1,n+1)) <= wid/2 ) )
      n = n+1;
   end%while( ( n<N )&( abs(tmp(1,n)-tmp(1,n+1)) <= wid/2 ) )
   out(1,m) = mean(tmp(1,p:n));
   out(2,m) = mean(tmp(2,p:n));
   m = m+1;
   n = n+1;
end%while( n <= N )