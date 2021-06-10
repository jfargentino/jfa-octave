function out=uniquearrays(A)
%uniquearrays(A) removes rotations and flips from a set of arrays

%	Removes rotations and flips from a set of Costas arrays.
%	After sorting, the first input row is taken and all flips and rotations
%   are removed, then the second, and so on until all arrays are unique.
%	Function does not output minimal arrays, only unique arrays from
%   sorted input set.
%
%	Examples
%   --------
%		uniquearrays([1 3 2;2 1 3])
%       % Output is [1 3 2]
%
%		uniquearrays([4 3 1 2;3 2 4 1;1 2 4 3])
%       % Output is [1 2 4 3;3 2 4 1]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin.

A=unique(A,'rows');
out = zeros(size(A));
count=0;
while size(A,1)>0
    count=count+1;
    out(count,:)=A(1,:);
    A=setdiff(A,dsyms(A(1,:)),'rows');
end
out=out(1:count,:);