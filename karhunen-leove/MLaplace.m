function Mask = MLaplace(N,a,b,r)

%Mask = MLaplace(N,a,b,r)
%
%  Retourne un masque laplacien Mask de N sur N 
%(si N paire, il est remplace par N+1), tel que :
%
%                          1        (j-p-1)²   (i-p-1)²   2r(j-p-1)(i-p-1) 
%    Mask(i,j) = exp[ - ------- * ( -------- + -------- + ---------------- ) ]
%                       2(1-r²)        a²         b²            a  b
%
%ou :
%        p=(N-1)/2 si N impaire, p=N/2 si N paire, r ~= 1, a & b ~= 0.
%
switch( nargin )
case 0,
   N = 256;
   a = 1;
   b = 1;
   r = 0;
   
case 1,
   a = 1;
   b = 1;
   r = 0;
   
case 2,
   b = 1;
   r = 0;
   
case 3,
   r = 0;
   
case 4,
   
otherwise,
   disp('Nb d''arguments incorrect' );
   return;
   
end

if(a&b)
   c=1/a^2;
   d=1/b^2;
   e=2*r/(a*b);
else
   disp('erreur, a et b doivent etre non nuls');
   Mask=ones(N,N);
   return
end

if( mod(N,2)==0 )
   N=N+1;
end


%while ( N > 19)
%   M=N;
%   disp('attention N est superieur a 11,');
%   disp('taper sur entree pour continuer');
%   N = input('ou entrer un autre N : '); 
%   if(isempty(N))
%      N=M;
%      break
%   end
%end


if(r ~= 1)
   Mask = - ones(N,N) / ( 2*( 1-r^2 ) );
else
   disp('erreur, r ne peut etre egal a 1');
   %Mask=ones(N,N);
   return
end

p=(N-1)/2;

% Methode bourin
for(i=1:N)
   for(j=1:N)
      Mask(i,j) = exp( Mask(i,j) * ( c*(j-p-1)^2 + d*(i-p-1)^2 + e*(j-p-1)*(i-p-1) ) );
   end
end

% Methode tableau 1
%tmp = zeros( N, N );
%for(i=1:N)
%   for(j=1:N)
%      tmp(i,j) = ( c*(j-p-1)^2 + d*(i-p-1)^2 + e*(j-p-1)*(i-p-1) );
%   end
%end
%Mask = exp( Mask .* tmp );

if( ~nargout )
   
   figure;
   
   subplot( 3, 1, 1 );
   imagesc( Mask );
   grid on;
   colormap( 'hot' );
   colorbar;
   
   subplot( 3, 1, 2 );
   plot( Mask( (N-1)/2, : ) );
   grid on;
   
   subplot( 3, 1, 3 );
   plot( Mask( :, (N-1)/2 ) );
   grid on;
   
   clear Mask;
   
end
