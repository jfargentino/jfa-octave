function Br = gray2btr( Gr )
%  Br = gray2btr(Gr)  converts an  m-by-n  array  Gr  of
%   ones and zeros whose rows represent  Gray  codes into
%   the array of ones and zeros whose bit-rows represent 
%   corresponding binary integers least-sig-bit first.
%   Gr  is treated as if  Gr = (Gr ~= 0) .  The time
%   taken is proportional to  m*n .
%  The function inverse to  gray2btr  is  btr2gray  in
%   so far as   btr2gray(gray2btr(Gr)) == (Gr ~= 0) .
%  See also  graystep  and  grays.

%  Adapted from  gray2bi  of  adrian@ubicom.tudelft.nl
%   and sped up by  W. Kahan,              13 Feb. 2009

Gr = (Gr ~= 0) ;  [m,n] = size(Gr) ;  
Br = Gr ;  %...  allocates memory for  Br  just once.
for  j = n-1:-1:1,
    Br(:,j) = xor( Br(:,j+1), Gr(:,j) ) ;  end
