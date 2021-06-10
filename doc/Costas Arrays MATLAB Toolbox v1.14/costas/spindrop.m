function out=spindrop(A)
%spindrop(A) searches for Beard arrays of size n-1 by removing a corner dot.

%	Starts by generating all rotations and flips of the input array set.
%	All circular shifts of the resulting arrays are then found. Finally
%	a corner dot is removed from all arrays which possess one, then the 
%   resulting Costas arrays are taken as the output set.
%
%	Examples
%   --------
%		spindrop([1 3 2])
%       % Output is [1 2]
%
%		spindrop([1 2 4 3; 1 3 4 2])
%       % Output is [1 3 2]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.2
%	Copyright (c) 2009 by University College Dublin.

out=minimal(costas(crem('ul',circshifts(dsyms(A)))));
