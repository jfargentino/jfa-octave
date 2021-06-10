function out=zeropad(ha)
%zeropad(ha) pads the border of a hit array (ha) with zeros.

%   This function adds zeros around the border of a hit array.
%   It is useful when used with mesh.
%   For example, rather than mesh(ha), try mesh(zeropad(ha)).
%
%	Example
%   -------
%		zeropad(1)
%       % Output is [0 0 0;0 1 0;0 0 0]
%
%		zeropad([1 2;2 1])
%       % Output is [0 0 0 0;0 1 2 0;0 2 1 0;0 0 0 0]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin.

[r c]=size(ha);
out=zeros(r+2,c+2);
out(2:r+1,2:c+1)=ha;