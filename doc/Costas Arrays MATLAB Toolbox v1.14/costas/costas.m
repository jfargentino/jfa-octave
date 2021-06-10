function out = costas(A)
%costas(A) outputs all Costas arrays from the set A

%   A function to output the Costas arrays from a set of multiple arrays 
%   in permutation form. All arrays must be of the same order.
%
%	Examples
%   --------
%		costas([1 2 3;])
%       % Output is [ ]
%
%		caddul([1 3 2;1 2 3;2 3 1])
%       % Output is [1 3 2;2 3 1]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin.

out=A(iscostas(A),:);
if size(out,1)<1
    out=[];
end