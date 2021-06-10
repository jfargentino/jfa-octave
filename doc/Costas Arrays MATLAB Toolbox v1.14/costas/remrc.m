function out = remrc(r,c,A)
%remrc(r,c,A) removes rows and columns from arrays

%   A function to remove rows and columns from an array or multiple arrays
%   in permutation form, where r is the row and c is the column to be 
%   removed from A.
%   Setting r=0 means removing only a column and vice-versa.
%   Blank columns are replaced by a NaN.
%
%	Examples
%   --------
%		remrc(0,2,[1 3 2])
%       % Output is [1 2]
%
%		remrc(1,2,[1 4 2 3;4 1 3 2])
%       % Output is [NaN 1 2;3 2 1]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin.

out=A;              % output original array if r & c are 0
if c>0
    A(:,c)=[];      % remove column c
    out=A;
end
if r>0
    A(A==r)=NaN;    % if removed row encludes a dot, set to NaN
    check=(A>=r);   % find which array values are below the removed row
    A=A-check;      % decrement these values
    check=(A==0);   % - set zeros to NaN
    A(check)=NaN;   % /
    out=A;
end