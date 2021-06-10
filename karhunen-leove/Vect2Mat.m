function Mat = Vect2Mat(Vect,i)

[ n , m ] = size(Vect);
n=round(sqrt(n));
Mat=zeros(n,n);
if( (i<=m)&(i>0) )
   Mat(:)=Vect(:,i);
else
   return;
end;%if
Mat=Mat';

