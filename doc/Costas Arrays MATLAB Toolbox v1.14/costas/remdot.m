function out = remdot(r,c,A)
%remdot(r,c,A) removes a dot from arrays

%   A function to remove a dot from an array or multiple arrays in 
%   permutation form,  where r is the row, and c is the column where the 
%   dot is to be removed from an array A, and replaced with a NaN.
%   If an array contains a dot in a different row in the column specified,
%   then the array is ignored. Arrays already containing a NaN in the
%   specified column are also included.
%
%	Examples
%   --------
%		remdot(1,2,[3 1 2])
%       % Output is [3 NaN 2]
%
%		remdot(2,2,[1 2 NaN 3])
%       % Output is [1 NaN NaN 3]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin.

A=A(logical((A(:,c)==r)+(isnan(A(:,c)))),:);
if size(A,1)==0
    out=[];
    return
end
A(:,c)=NaN;
out=A;