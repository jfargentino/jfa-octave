function out = dsyms(A)
%dsyms(A) generates all rotations and flips of arrays

% 	Generates the family of arrays in the dihedral symmetry class for 
% 	the sequences in the input matrix (i.e. all rotations and flips).
%
%	Examples
%   --------
%		dsyms([1 3 2])
%       % Output is [1 3 2;2 1 3;2 3 1;3 1 2]		
%	
%		dsyms([1 3 2 4;1 2 4 3])
%       % Output is [1 2 4 3;1 3 2 4;2 1 3 4;3 4 2 1;4 2 3 1;4 3 1 2]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin. 

[num,N]=size(A);
[junk,A1]=sort(A,2);
out=unique([A;fliplr(A);N-A+1;fliplr(N-A+1);A1;fliplr(A1);N-A1+1;fliplr(N-A1+1)],'rows');