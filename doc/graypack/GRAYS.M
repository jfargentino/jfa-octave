function  G = grays(n)
%  G = grays(n)  is a column of  2^n  distinct  n-bit integers
%   that step through consecutive  Gray Codes  running from
%   G(1) = 0  to  G(2^n) = 2^(n-1) = 100...000 (2) ,  but each
%   G(j+1)  is obtained from  G(j)  by changing just one bit of
%   G(j) .  To see which bit,  compute  M = grayndcs(n) ;  then
%        G(j+1) - G(j) = sign(M(j))*2.0.^(abs(M(j)) - 1) .
%  Display  G + 2^52  in  hex  to see its last  n  bits change.
%  Keep  n < 33  because both  grays(n)  and  grayndcs(n)  cost
%   time and memory proportional to  2^n .
%  See also  grayndcs, graynext, int2gray, gray2int, gray2btr,
%  graystep, btr2gray, btr2int and int2btr .
%                              W. Kahan,   1996 to 26 Feb. 2009

n = n(:) ;  T = length(n) ;
if ( (T~=1)|(n~=round(n))|(n<1)|(n>32) ),  N = n ,
  error(' grays(N)  needs a small positive integer  N .'),  end
G = zeros(2^n,1) ;  G(2) = 1 ;  T = 2 ; %... preallocate memory
for  k = 2:n  %...  Recurrence,  NOT  Recursion
    T2 = T+T ;  %... = 2^k
    G(T+1:T2) = T + G(T:-1:1) ;
    T = T2 ;  end

