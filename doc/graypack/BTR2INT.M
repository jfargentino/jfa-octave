function K = btr2int( Br )
%  K = btr2int(Br)  converts an  m-by-n  logical array
%   (Br ~= 0)  whose bit-rows represent unsigned binary
%   integers,  least-sig-bit first,  into the column of
%   these  m  integers.  WARNING:  These may get rounded
%   to 53 sig. bit even integers if  n > 53 .  Otherwise
%   the inverse of  btr2int  is  int2btr  in so far as
%         int2btr(btr2int(Br), n) == (Br ~= 0) .
%  To reinterpret the bit-rows of  (Br ~= 0)  as  n-bit
%   2's complement integers,  unless  n > 53 ,  replace
%   K  by  K - (K >= 2^(n-1))*2^n .
%                                W. Kahan,  12 Jan. 2009

Br = (Br ~= 0) ;  [m,n] = size(Br) ;
K = Br*cumprod([1; ones(n-1,1)*2]) ;
