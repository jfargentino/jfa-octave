function  g = int2gray(k, n)
%  g = int2gray(k, n) = G(1+mod(k,2^n)) ,  where  G = grays(n) ,
%   quickly without generating all  2^n  elements of  G ,  but
%   ONLY if integer  |k| <= 2^53 = bitmax + 1 .  If  k  is an
%   array it determines  g  of the same size elementwise.  If  n
%   is omitted it defaults to  n = 53 ;  else keep  0 < n < 54 .
%  NOTE:  int2gray  works only for  MATLAB 5  and later versions.
%  See also  grays,  grayndcs,  gray2int  and  graynext .
%                                      W. Kahan,  15 Feb. 2009

if (any((k(:) ~= round(k(:)))|(abs(k(:)) > bitmax+1))),  K = k ,
    error(' int2gray(K,n)  needs an array K of small integers.')
  end
if (nargin < 2),  n = 53 ;  else
   if ( (n ~= round(n))|(n < 1)|(n > 53) ),  N = n
      error(' int2gray(k,N)  needs positive integer  N < 54 .')
  end, end
negk = (k < 0) ;  if any(negk(:)),  k = k + negk*2^53 ;  end
k = bitand(2^n - 1, k) ;  %...  = mod(k, 2^n)  quickly
g = bitxor(k, fix(0.5*k)) ;
