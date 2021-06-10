function out=spindrop2(A)
%spindrop2(A) searches for Beard arrays of size n-2 by removing corner dots.

%	Starts by generating all rotations and flips of the input array set.
%	All circular shifts of the resulting arrays are then found. Finally
%	the corner dots are removed from all arrays which possess two of them 
%   at opposing corners, then the resulting Costas arrays are taken as the 
%   output set.
%
%	Examples
%   --------
%		spindrop2([1 3 4 2 5])
%       % Output is [1 3 2]
%
%		spindrop2([1 4 5 3 2 6; 1 5 4 2 3 6])
%       % Output is [1 2 4 3]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.2
%	Copyright (c) 2009 by University College Dublin.

out=minimal(costas(crem('ul',crem('lr',circshifts(dsyms(A))))));