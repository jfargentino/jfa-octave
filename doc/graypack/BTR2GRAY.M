function Gr = btr2gray( Br )
%  Gr = btr2gray(Br)  converts an  m-by-n  array  Br  of
%   ones and zeros whose rows represent binary integers
%   least-sig-bit first into the array of ones and zeros
%   whose bit-rows represent corresponding  Gray  codes.
%   Br  is treated as if  Br = (Br ~= 0) .  The time
%   taken is proportional to  m*n .
%  The function inverse to  btr2gray  is  gray2btr  in
%   so far as   gray2btr(btr2gray(Br)) == (Br ~= 0) .
%  See also  graystep  and  grays.

%  Adapted from  bi2gray  of  adrian@ubicom.tudelft.nl
%   and sped up by  W. Kahan,              13 Feb. 2009

Br = (Br ~= 0) ;  [m,n] = size(Br) ;  z = zeros(m,1) ;
Gr = xor( Br,  [Br(:,2:n), z] ) ;
