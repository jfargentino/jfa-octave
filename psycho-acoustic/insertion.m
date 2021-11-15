function Cout = insertion( array, Cin, index )
%
%function Cout = insertion( array, Cin, index )
%
%   Insertion d'un tableau a la cellule n° 'index'
%de la cell 'Cin', les cellules d'apres sont decalees.
%
%
%Voir aussi FUSION, , CELL_FUSION, MEAN_HARMONICS.
%

N    = length(Cin);
Cout = cell(1,N+1);

if( ( index > 1 ) & ( index <= N ) )	
	[Cout{1:index-1}]=deal(Cin{1:index-1});
   Cout{index}=array;
   [Cout{index+1:N+1}]=deal(Cin{index:N});

else%if( ( index <= 1 ) | ( index > N ) )
   
   if( index <= 1 )
   	Cout{1}=array;
   	[Cout{2:N+1}]=deal(Cin{:});

	else%if( index > N )
   	[Cout{1:N}]=deal(Cin{:});
   	Cout{N+1}=array;
      
   end%if( index <= 1 )
   
end%if( ( index > 1 ) & ( index < N ) )
