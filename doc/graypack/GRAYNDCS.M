function  M = grayndcs(n)
%  M = grayndcs(n)  is a column of  2^n  integer indices
%   that reveal which bit changes among consecutive  Gray 
%   Codes  in  G = grays(n) ,  and in which direction.
%   Counting up from  1  for the least-significant bit 
%   (the rightmost),  bit number  |M(1+k)|  of  G(1+k)
%   changes by  sign(M(1+k)) ,  but no other bit changes,
%   upon going to  G(1 + mod(k+1, 2^n))  for each index
%   k  in  0 <= k < 2^n .  Keep  n < 33  because the time
%   and memory consumed by  grayndcs(n)  is proportional
%   to  2^n .  See also  graynext, int2gray, gray2int,
%   graystep, gray2btr, btr2gray, btr2int and int2btr .   
%                               W. Kahan,  14 Feb. 2009

n = n(:) ;  T = length(n) ;
if ( (T~=1)|(n~=round(n))|(n<1)|(n>32) ),  N = n ,
  error(' grayndcs(N)  needs a small positive integer  N .')
 end
M = ones(2^n,1) ;  T = 1 ;  T2 = 2 ;
if n > 1 ,  for  k = 2:n
    T4 = T2+T2 ;  %... = 2^(k+1) ,  T2 = 2^k ,  T = 2^(k-1)
    M(T2) = k ;  M(T2+1:T4-1) = -M(T2-1:-1:1) ; 
    T = T2 ;  T2 = T4 ;  end, 
  else  k = 1 ;  end
M(T2) = -k ;

