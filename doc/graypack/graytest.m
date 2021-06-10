function  passfail = graytest(n)
%  graytest(n)  tests  GrayPack's  other ten  MATLAB  programs
%    grays       gray2int    int2gray    btr2int    graynext
%    grayndcs    gray2btr    btr2gray    int2btr    graystep
%  upon  n-bit  Gray Codes  and their conversions for any integer
%  n > 0  at the cost of time and memory proportional to  n*2^n .
%                                         W. Kahan,  15 Feb. 2009
if ((length(n(:))~=1)|any((n<0)|(n~=round(n))|(n>32))) ,  N = n
    error(' graytest(N)  needs one small integer  N > 0 .'),  end
disp([' Begin  graytest(', int2str(n),').'])

C = cumprod([1;2*ones(53,1)]) ;  %... = 2.0.^[0:53]'
B = log2(C) ;  if any(B - [0:53]'),  K = find(B - [0:53]') ;
   K_log22K = [K-1, B(K)]
   error(' graytest FAILURE: log2(2^K) ~= K '),  end
clear  K  B

t53 = C(53) ;  tn = C(n+1) ; %... = 2^n
K = [-tn-1:tn+1]' ;  L = n+1 ;

disp(' Testing  int2btr  and  btr2int :')
B = int2btr(0*K) ;  if any(B - 0*K), N = n
   error(' int2btr(0)  FAILED  graytest(N).'),  end
KL = btr2int(B) ;  if any(KL - 0*K),  N = n
   error(' btr2int(0)  FAILED  graytest(N).'),  end
B = int2btr(K) ;  R = B*C(1:L) ;
KL = bitand(C(L+1)-1, K + (K<0)*C(54)) ;
if any(KL - R),  N = n
   error(' int2btr(K)  FAILED  graytest(N).'),  end
if any(btr2int(B) - R),  N = n
   error(' btr2int(B)  FAILED  graytest(N).'),  end
B = int2btr(K,n) ;  R = B*C(1:n) ;
KL = bitand(C(n+1)-1, K + (K<0)*C(54)) ;
if any(KL - R),  N = n
   error(' int2btr(K,N)  FAILED  graytest(N).'),  end
if any(btr2int(B) - R),  N = n
   error(' btr2int(B)  FAILED  graytest(N).'),  end
clear  KL  R  B  L  K

disp(' Testing  grays  and  grayndcs :')
G = grays(n) ;  G1 = [G(2:tn); 0] ;  K = [0: tn-1]' ;
B = G1 - G ;  M = log2(abs(B)) ;
if ( any(M - round(M))|(G(tn) - C(n))|G(1) ) ,  N = n 
    K_G_B = [K, G, B]
    error(' G = grays(N)  FAILED graytest(N) .'),  end
L = grayndcs(n) ;  if any(L - (M+1).*sign(B)),  N = n
    K_G_B_L_M1 = [K, G, B, L, M+1]
    error(' L = grayndcs(N)  FAILED  graytest(N) .'),  end
clear L  M  B

disp(' Testing  gray2int  and  int2gray :')
KG = gray2int(G) ;  GK = int2gray(K) ;
if any((G-GK)|(K-KG)) ,  N = n ,  K_G_GK_KG = [K, G, GK, KG]
    error(' int2gray  or  gray2int  FAILED  graytest(N) .')
  end
clear  KG  GK
GK = int2gray([K-tn,K,K+tn], n) ;
if any(any(GK - [G,G,G])),  N = n,  K_Gs = [K, GK]
    error(' int2gray  FAILED  graytest(N) .')
  end
clear  GK  K
nn = n + round(rand(1)*(n+3)) ;
X = fix(rand(nn)*tn) ;  Y = fix(rand(nn)*tn) ;
Z = bitxor(X, Y) ;
W = bitxor(gray2int(X), gray2int(Y)) ;
jz = find(gray2int(Z) ~= W) ;
if any(jz),  N = n ,  XYZW = [X(jz), Y(jz), Z(jz), W(jz)]
    error(' gray2int  FAILED  to commute with  bitxor.')
  end
W = bitxor(int2gray(X,n), int2gray(Y,n)) ;
jz = find(int2gray(Z,n) ~= W) ;
if any(jz),  N = n ,  XYZW = [X(jz), Y(jz), Z(jz), W(jz)]
    error(' int2gray  FAILED  to commute with  bitxor.')
  end
clear  jz  W  Z  Y  X  nn

disp(' Testing  graynext :')
H = graynext(+1, G, n) ;  if any(H - G1),  N = n
    G_G1_H = [G, G1, H] 
    error(' graynext(+1, G, N)  FAILED  graytest(N) .')
  end
H = graynext(-1, G1, n) ;  if any(H - G),  N = n
    G1_G_H = [G1, G, H] 
    error(' graynext(-1, G, N)  FAILED  graytest(N) .')
  end
G1(tn) = tn + G(tn) ;
H = graynext(+1, G) ;  if any(H - G1),  N = n
    G_G1_H = [G, G1, H] 
    error(' graynext(+1, G)  FAILED  graytest(N) .')
  end
H = graynext(-1, G1) ;  if any(H - G),  N = n
    G1_G_H = [G1, G, H] 
    error(' graynext(-1, G)  FAILED  graytest(N) .')
  end
clear  H  G1

disp(' Testing  graystep :')
Gr = zeros(tn+1, n) ; %... to initialize  Gr  in memory
for j = 1:tn ,  Gr(j+1,:) = graystep(-1, Gr(j,:)) ;  end
Gi = btr2int(Gr) ;
if any(flipud([G;0]) - Gi) ,  N = n 
    G_Gi_Gr = [flipud([G;0]), Gi, Gr]
    error(' graystep(-1, Gr)  FAILED  graytest(N) .'),  end
for j = 1:tn ,  Gr(j+1,:) = graystep(+1, Gr(j,:)) ;  end
Gi = btr2int(Gr) ;
if any([G;0] - Gi) ,  N = n ,  G_Gi_Gr = [[G;0], Gi, Gr]
    error(' graystep(+1, Gr)  FAILED  graytest(N) .'),  end
clear  G

disp(' Testing  gray2btr  and  btr2gray :')
Br = gray2btr(Gr) ;  Bi = btr2int(Br) ;  K = [[0:tn-1],0]' ;
if any(Bi - K),  N = n ,  K_Gi_Bi = [K, Gi, Bi]
    error(' gray2btr  FAILED  graytest(N) .'),  end
Gr = btr2gray(Br) ;  Gb = btr2int(Gr) ;
if any(Gb - Gi),  N = n ,  K_Gi_Gb = [K, Gi, Gb]
    error(' btr2gray  FAILED  graytest(N) .'),  end
nn = n + round(rand(1)*(n+3)) ;
X = round(rand(nn,n)) ;  Y = round(rand(nn,n)) ;
Z = xor(X, Y) ;
W = xor(gray2btr(X), gray2btr(Y)) ;
jz = find(gray2btr(Z) ~= W) ;
if any(jz),  N = n ,  XYZW = [X(jz), Y(jz), Z(jz), W(jz)]
    error(' gray2btr  FAILED  to commute with  xor.')
  end
W = xor(btr2gray(X), btr2gray(Y)) ;
jz = find(btr2gray(Z) ~= W) ;
if any(jz),  N = n ,  XYZW = [X(jz), Y(jz), Z(jz), W(jz)]
    error(' btr2gray  FAILED  to commute with  xor.')
  end
clear  jz  W  Z  Y  X  nn

passfail = [' graytest(', int2str(n), ')  has PASSED.'] ;
return

