function out=isdiagonal(A)
%isdiagonal(A) determines if sequences are symmetric about the main 
%diagonal 

%	Determines whether or not an array is symmetric about the main diagonal
%   and returns a 1 or a 0. 
%   Also works for multiple arrays, returning a column.
%	
%	Examples
%   --------
%		isdiagonal([1 2])
%       % Output is [1]
%
%		isdiagonal([1 2 4 3;1 4 2 3])
%       % Output is [1;0]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin.

[junk,A1]=sort(A,2);            % get the main diagonal flips
out=all(A==A1,2);