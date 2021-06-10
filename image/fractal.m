close all
clear all
clc
cr=0.181;
ci=-0.667;
dx=0.001;
minx=-1.3;
maxx=1.3;
n = 20;
M = 100;
x=minx:dx:maxx;
y=minx:dx:maxx;
[X,Y]=meshgrid(x,y);
for j=1:n
   Zr=X.^2-Y.^2+cr;
   Zi=2*X.*Y+ci;        
   Zr(Zr>M)=M;
   Zr(Zr<-M)=-M;
   Zi(Zi>M)=M;
   Zi(Zi<-M)=-M; 
   X=Zr;
   Y=Zi;
end
subplot(121)  
imagesc(X);axis equal
subplot(122)  
imagesc(Y);axis equal
FILE=(['fractal.png']);
print(FILE,"-dpng")

