function out=findcostas(n)
%findcostas(n) generates all Costas arrays for small sizes

%	Generates all Costas arrays for a given input size by exhaustively
%	searching through permutations. Intended use is for small size arrays
%
%	Example
%   -------
%		findcostas(2)
%       % Output is [1 2;2 1]
%
%		findcostas(3)
%       % Output is [1 3 2;2 1 3;2 3 1;3 1 2]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin.

a=perms(1:n);
b = iscostas(a);
out=sortrows(a(logical(b),:));