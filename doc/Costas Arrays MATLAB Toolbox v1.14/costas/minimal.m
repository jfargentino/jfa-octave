function out=minimal(A)
%minimal(A) replaces arrays with minimal flip or rotation

%	Replaces input arrays with their flip or rotation which is minimal,
%	then returns sorted unique arrays.
%	All input arrays must be of the same length.
%	
%	Examples
%   --------
%		minimal([3 1 2])
%       % Output is [1 3 2]
%
%		minimal([4 3 1 2;3 2 4 1])
%       % Output is [1 2 4 3;1 3 4 2]		

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin.

nrows=size(A,1);
for i=1:nrows
   x=dsyms(A(i,:));
   A(i,:)=x(1,:);
end
out=unique(A,'rows');