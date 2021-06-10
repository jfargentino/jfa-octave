function out = cadd(loc,A)
%cadd(loc,A) adds a corner dot at location 'loc'

%   A function to add a corner dot to corners of an array or 
%   multiple arrays in permutation form. Outputs minimal versions 
%   of all arrays regardless of whether or not the result is Costas.
%
%	Examples
%   --------
%		cadd('all',[1 2])
%       % Output is [1 2 3;1 3 2]
%
%		cadd(ul,[1 3 2;2 1 3])
%       % Output is [1 2 4 3;1 3 2 4;1 3 4 2]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.2
%	Copyright (c) 2009 by University College Dublin.

num=size(A,1);
if strcmp('ul',loc)
    out=[ones(num,1) A+1];              % add upper left corner dot
elseif strcmp('ur',loc)
    out=[A+1 ones(num,1)];              % add upper right corner dot
elseif strcmp('ll',loc)
    out=[ones(num,1)+max(A,[],2) A];    % add lower left corner dot
elseif strcmp('lr',loc)
    out=[A ones(num,1)+max(A,[],2)];    % add lower right corner dot
elseif strcmp('all',loc)
    arrays=[ones(num,1) A+1;A+1 ones(num,1);[ones(num,1)+max(A,[],2) A];A ones(num,1)+max(A,[],2)];
    out=minimal(arrays);
end