function out=iscircshift(m1,m2)
%iscircshift(m1,m2) determines if an array m1 is a circular shift of
%array m2.
%
%	cl_IsCircShift(m1,m2) determines whether an array m1 is a circular 
%   shifted version of array m2 and returns a 1 or a 0. Also works for 
%   multiple arrays, returning a column.
%	
%	Examples
%   --------
%		iscircshift([1 3 2],[2 1 3])
%       % Output is [1]
%
%		iscircshift([1 2 4 3;1 4 2 3],[2 4 3 1])
%       % Output is [1;0]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1 
%	Copyright (c) 2008 by University College Dublin.

num=size(m1,1);
out=false(num,1);
for i=1:num
    circshifts=op_CircShifts(m2);
    if ArrayIsACircshift(m1(i,:),circshifts) 
         out(i)=true;
    end
end

function out=ArrayIsACircshift(row_i,circshifts)
% check if array is one of the circular shifts
out=ismember(row_i,circshifts,'rows');