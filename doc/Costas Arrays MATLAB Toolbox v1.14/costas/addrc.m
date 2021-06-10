function out = addrc(r,c,A)
%addrc(r,c,A) adds blank rows and columns to arrays

%   A function to add blank rows and columns to an array or multiple arrays
%   in permutation form, where r is the row and c is the column to be 
%   added to an array or arrays A.
%   Setting r=0 means adding only a column and vice-versa.
%   Blank columns are represented by a NaN.
%
%	Examples
%   --------
%		addrc(0,2,[1 2])
%       % Output is [1 NaN 2]
%
%		addrc(2,2,[1 3 2;3 1 2])
%       % Output is [1 NaN 4 3;4 NaN 1 3]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin.

out=A;
if r>0
    check=(A>=r);   % find which array values will be below the added row
    out=A+check;    % increment these values
end
if c>0
   out=[out(:,1:c-1) NaN(size(A,1),1) out(:,c:end)]; % add the blank column
end