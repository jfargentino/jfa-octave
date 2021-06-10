function Noyau = Im2Noyau(Image)
%
%function Noyau = Im2Noyau(Image)
%
%Image = une matrice carree N*N ou N impaire
%Noyau = le tenseur de dim 4 mis sous forme de matrice N²*N²
%
[N,N]=size(Image);
if(~mod(N,2))
   N=N-1;
end
p=(N+1)/2;

corr=xcorr2(Image)/(N*N);

Noyau=zeros(N*N,N*N);
n=1;
for(r1=1:N)
   for(r2=1:N)
      m=1;
      for(i=1:N)
         for(j=1:N)
            Noyau(n,m)=corr(r1-i+N,r2-j+N);
            m=m+1;
         end
      end
      n=n+1;
   end
end
