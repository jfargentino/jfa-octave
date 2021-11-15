function out = cell_fusion( in1, in2, wid )
%
%fonction cout = cell_fusion( cin1, cin2 [, wid ] )
%
%   Fonction permettant la fusion des deux tableaux de cellules
%'cin1' et 'cin2' en une seule 'cout'. 'wid' est la difference
%maximale entre deux frequence qui seront considerees comme egale
%par l'algo, 'wid' est a 4 Hz par defaut. 
%
%
%Voir aussi FUSION, INSERTION, CELL_SORT, MEAN_HARMONICS, 
%           MEAN_PERT_HARM.
%

switch( nargin )
case 2,
   wid = 4;
case 3,
otherwise,
   return
end

L1 = length( in1 );
L2 = length( in2 );

if( ~L1 )
   out = in2;
   return
end

if( L1 > L2 )
   out = in1;
end%if( L1 > L2 )

if( L1==L2 )
   if( in1{1}(1,1)>=in2{1}(1,1) ) 
      out = in2;
 		in2 = in1;
	else
      out = in1;   
   end
end%if( L1==L2 )

if( L1 < L2 )
	out = in2;
   in2 = in1;
end%if( L1 > L2 )

L2 = length( in2 );
L  = length( out );

%pour toutes les cases de in2
for( n2 = 1:L2 )
	n   = 1;
	ok  = 1;
   
   while( (ok)&(n<=L) )
            
   	%si les deux fondamentales sont egales
      if( (abs( in2{n2}(1,1)-out{n}(1,1) ) <= wid/2) | ...
          (abs( in2{n2}(1,1)/2-out{n}(1,1) ) <= wid/2) )
      	out{n} = fusion( in2{n2}, out{n} );
         ok     = 0;
               
      else%( in2{n2}(1,1) ~= out{n}(1,1) )
               
      	if( in2{n2}(1,1) < out{n}(1,1) )
         	out  = insertion( in2{n2}, out, n );
            L    = L + 1;
            ok   = 0;
                  
         else%( in2{n2}(1,1) > out{n}(1,1) )
         	n = n + 1;
            if( n > L )
            	out = insertion( in2{n2}, out, n );
               L   = L + 1;
               ok  = 0;
          	end
                  
         end%if( in2{n2}(1,1) > out{n}(1,1) )
               
      end%if( abs( in2{n2}(1,1)-out{n}(1,1) ) <= wid/2 )
            
   end%while( ()&() )  
   
end%for( n2 = 1:L2 )
