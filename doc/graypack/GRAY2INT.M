function  k = gray2int(g)
%  k = gray2int(g)  solves  g = int2gray(k)  for  k ,
%   but ONLY if nonnegative integer array  g <= bitmax .
%  The time taken is proportional to the number of bits 
%   needed to hold  g .  NOTE:  gray2int  works only for
%   MATLAB 5  and later versions.
%  See also  grays,  int2gray,  grayndcs  and  graynext.
%                                 W. Kahan,  8 July 2007

if(any(any( (g<0)|(g~=round(g))|(g>bitmax) ))),  G = g,
    error(' gray2int(G)  needs an array G of small nonnegative integers.')
  end
k = g ;
while any(g(:))
    g = fix(0.5*g) ;  k = bitxor(k, g) ;  end
