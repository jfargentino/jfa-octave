function sequ = dirac_sequence( f0, nb, fs, len, wid )
%
%function sequ = dirac_sequence( f0 [, nb, fs, len, wid ] )
%
%Generation d'un 'vrai' peigne de dirac.
%Les valeurs par defaut sont:
%
%       - 'nb'  = le nb max de dirac possible.
%       - 'fs'  = 44100 Hz,
%       - 'len' = 32768 echantillons,
%       - 'wid' = 4 Hz.
%
%   Si 'nb' est a zero, il y aura le nombre maximal de dirac.
%'wid' est la largeur des dirac. 
%
%Voir aussi GET_HARMONICS, MEAN_HARMONICS.
%

switch( nargin )
   
   case 1 ,
   nb  = 0;   
   fs  = 44100;
   len = 32768;
   wid = 4;
   
   case 2 ,
   fs  = 44100;
   len = 32768;
   wid = 4;
   
   case 3,
   len = 32768;
   wid = 4;
   
   case 4,
   wid = 4;
      
   otherwise
   if( nargin==5 )
      %wid = floor(wid/2);
   else
      disp('Error, invalid number of arguments.')
   end
       
end% switch( nargin )

%conversion de la largeur en 
%hertz en nb d'echantillons
wi  = floor(wid*len/fs);

if( nb )
   noct = min(nb,floor(fs/(2*f0))-1);
else%( nb==0 )
   noct = floor(fs/(2*f0))-1;
end%if( nb )

indx = repmat(round((1:noct)*(2*len*f0./fs))+1, 2*wi+1, 1) + ...
					repmat((-wi:1:+wi)', 1, noct);
sequ = full(sparse(1,indx(:),1,1,len))';

if( ~nargout )%si il n'y a pas de sortie...
   incr  = fs/(2*len);%pas de frequence
   plot(0:incr:(len-1)*incr,sequ)
   title([num2str(noct),' dirac de largeur ',num2str(wid),...
          ' Hz, freq fondamentale ',num2str(f0),' Hz.'])
   grid on
   clear sequ
end% if( ~nargout )

%d'autres methodes moins efficaces
%inc     = fs/(2*len);
%sequ    = ( mod(inc*(0:len-1),f0) <= inc );
%sequ(1) = 0;
%delta = floor(2*len*f0/fs)+1;
%sequ  = ~( mod(0:len-1,delta) );
%sequ(1) = 0;
