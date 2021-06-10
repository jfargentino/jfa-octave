function out=spinadd2(A)
%spinadd2(A) searches for Beard arrays of size n+2 by adding corner dots.

%	Starts by generating all rotations and flips of the input array set.
%	All circular shifts of the resulting arrays are then found. Finally
%	two corner dots are added to all arrays and the Costas arrays from this 
%   set are taken as the output.
%
%	Examples
%   --------
%		spinadd2([1 3 2])
%       % Output is [1 3 4 5 2]
%
%		spinadd2([1 2 4 3])
%       % Output is [1 4 5 3 2 6]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.2
%	Copyright (c) 2009 by University College Dublin.

out=minimal(costas(cadd('ul',cadd('lr',circshifts(dsyms(A))))));