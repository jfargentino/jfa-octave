function dual = dualwin( window, jump )

K    = length( window ); 
dual = window / K;

for( k = 1 : K )
   n = k - ( ceil( (k-K)/jump ) : floor( (k-1)/jump ) ) * jump;
   dual( k ) = dual( k ) / sum( window(n) .* window(n) );
end

% Code Monika Dörfler
%K    = length( window ); 
%dum  = zeros( K, 1 );
%win2 = [ window.^2; window.^2 ] * K;
%
%for( k = 1 : K / jump )
%   dum = dum + win2( (k-1)*jump+1 : (k-1)*jump+K );
%end
%
%dual = window ./ dum;
   
