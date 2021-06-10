function Noyau = GNoyauM1(c,p)
%
%function Noyau = GNoyauM1(c,p)
%
%c     = 0<c<1, 'bande passante'
%p     = un nb entier
%Noyau = le tenseur de dim 4 mis 
%        sous forme de matrice N*N
%        avec N=(2*p+1)²
%

N=(2*p+1)*(2*p+1);

Noyau=zeros(N,N);
n=1;
for(r1=-p:p)
   for(r2=-p:p)
      m=1;
      for(i=-p:p)
         for(j=-p:p)
            Noyau(n,m) = sinc(c*(r1-i)) * sinc(c*(r2-j));
            m=m+1;
         end
      end
      n=n+1;
   end
end

