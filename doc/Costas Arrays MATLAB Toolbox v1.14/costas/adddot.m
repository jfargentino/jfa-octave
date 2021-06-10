function out = adddot(r,c,A)
%adddot(r,c,A) adds a dot to arrays

%   A function to add a dot to an array or multiple arrays in permutation 
%   form, where r is the row, and c is the column where the dot is to be 
%   added to an array A.
%   A dot can only be added to an array if the column is empty (a NaN).
%   If an array is not empty in the specified column then it is ignored,
%   unless it already contains the desired value.
%
%	Examples
%   --------
%		adddot(1,2,[2 NaN 3])
%       % Output is [2 1 3]
%
%		adddot(2,2,[1 NaN NaN 3;NaN 3 1 2])
%       % Output is [1 2 NaN 3]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin.

A=A(logical((A(:,c)==r)+(isnan(A(:,c)))),:);     % remove unwanted arrays
if size(A,1)==0
    error('No arrays were empty at the specified location')          
else
    A(:,c)=r;                     % set the value
    out=A;                        % ouput the new array
end