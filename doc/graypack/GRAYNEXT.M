function  h = graynext(d, g, n)
%  h = graynext(d, g, n)  takes nonnegative integer array
%   g ,  interpreted as  n-bit  Gray Cyclic Binary Codes,
%   elementwise through one step forward,  if  d > 0 ,
%   or otherwise backward through the  Gray  codes,  so
%   h  and  g  have the same size.  If not a scalar,  d
%   must have that same size.  If omitted,  n  defaults 
%   to  n = 53 ;  otherwise keep  0 < n < 54 .  Requires
%   gray2int  and  int2gray.  See also  grays,  graystep,
%   and grayndcs.                 W. Kahan,  15 Feb. 2009
if (nargin < 3),  n = 53 ;  else
   if ( (n ~= round(n))|(n < 1)|(n > 53) ),  N = n
      error(' graynext(d,g,N)  needs positive integer  N < 54 .')
  end, end
if any (g(:) > 2^n - 1),  N = n,  G = g
    error(' graynext(d, G, N)  needs integers  G < 2^N .')
  end
h = int2gray( 2*(d>0)-1 + gray2int(g), n ) ;
