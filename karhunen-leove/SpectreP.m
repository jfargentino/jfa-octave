function Dsp = SpectreP(Texture)
%
%function Dsp = SpectreP(Texture)
%
%Texture : une image carree N*N
%
%Dsp     : un vecteur [1,N/2] representant
%          la densite spectrale de puissance
%          de l'image Texture.
%
%
[N,N]=size(Texture);
M=round(N/2);
ddsp=zeros(1,N);
for(i=1:N)
   temp=fft( Texture(i,:) )/(N*N);
   ddsp=ddsp+temp.*conj(temp);
end
dsp=ddsp(1:M);
mini=min(dsp);
amp=max(dsp)-mini;
Dsp=(dsp-mini)/amp;
