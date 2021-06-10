function out=isrotflip(m1,m2)
%isrotflip(m1,m2) if an array m1 is a rotation or flip of array m2

%	Determines whether an array m1 is a rotation or flip of 
%   array m2 and returns a 1 or a 0. Also works for multiple arrays,
%   returning a column.
%	
%	Examples
%   --------
%		isrotflip([1 3 2],[2 1 3])
%       % Output is [1]
%
%		isrotflip([1 2 4 3;1 4 2 3],[4 2 1 3])
%       % Output is [0;1]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.2
%	Copyright (c) 2009 by University College Dublin.

num=size(m1,1);
out=false(num,1);
for i=1:num
    rotsflips=dsyms(m2);
    if ArrayIsARotationOrFlip(m1(i,:),rotsflips)
         out(i)=true;
    end
end

function out=ArrayIsARotationOrFlip(row_i,rotsflips)
% check if array is one of the circular shifts
out=ismember(row_i,rotsflips,'rows');