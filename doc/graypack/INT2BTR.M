function  Br = int2btr(K, n)
%  Br = int2btr(K, n)  converts a column  K(:)  of  m
%    integers into an  m-by-n  logical array  Br  of ones
%    and zeros whose bit-rows represent the corresponding
%    binary integers in  mod(K(:), 2^n) ,  least-sig-bit
%    first.  Now let  L = 1 + floor(log2(max(|K(:)|))) .
%  If  n  is omitted it defaults to  n = L  unless
%    K == 0 ,  whereupon  Br = K(:)  is returned.
%  If  L > 53  or  n > 53  then  int2btr  will balk.
%  Otherwise if  any(K(:)) < 0  then the bit-rows of  Br
%    can be construed as  n-bit 2's complement integers
%    subject to integer overflow where  |K| >= 2^(n-1) .
%  Only for  K >= 0  is  btr2int  inverse to  int2btr
%    in the sense that  btr2int(int2btr(K)) == K(:) .

%  Only for  Matlab 5  and later.  W. Kahan,  15 Feb. 2009

K = K(:) ;  m = length(K) ;
if any(K ~= round(K)),  nonintegerK = K
   error('int2btr(K,n)  takes only integers in  K .')
  end
mxK = max(abs(K)) ;  L = -1 ;  %... no  log(0)  message:
if (mxK ~= 0),  L = 1 + floor(log2(mxK)) ;  end
%  O.K. only because  Matlab's  log2(2^n) == n  exactly.
if (nargin < 2),  if (L < 0),  Br = K ;  return, end
    n = L ;
  else
    if ((n ~= round(n))|(n < 1)),  N = n
       error('int2btr(K,N)  needs integer N > 0 .')
      end
   end
if ((L > 53)|(n > 53)),  N = n,  K = K
   error('int2btr(K,N)  needs  |K| < 2^53  and  N < 54 .') 
  end

nk = (K < 0) ;  if any(nk),  K = K + nk*(2/eps) ;  end
C = cumprod([1, ones(1,n-1)*2]) ;  %... = 2.0.^[0:n-1]
Br = ( bitand(C(ones(m,1),:), K(:,ones(1,n))) ~= 0 ) ;
