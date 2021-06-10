function out=spinadd(A)
%spinadd(A) searches for Beard arrays of size n+1 by adding a corner dot.

%	Starts by generating all rotations and flips of the input array set.
%	All circular shifts of the resulting arrays are then found. Finally
%	a corner dot is added to all arrays and the Costas arrays from this 
%   set are taken as the output.
%
%	Examples
%   --------
%		spinadd([1 2])
%       % Output is [1 3 2]
%
%		spinadd([1 3 2])
%       % Output is [1 2 4 3;1 3 4 2]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.2
%	Copyright (c) 2009 by University College Dublin.

out=minimal(costas(cadd('ul',circshifts(dsyms(A)))));