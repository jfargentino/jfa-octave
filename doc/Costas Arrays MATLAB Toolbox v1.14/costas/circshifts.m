function out=circshifts(A)
%circshifts(A) generates circular shifts of arrays

%	Generates all unique circular shifts of input arrays.
%
%	Examples
%   --------
%		circshifts([1 3 2])
%       % Output is [1 3 2; 2 1 3; 3 2 1]
%
%		circshifts([1 2;3 4])
%       % Output is [1 2;2 1;3 4;4 3]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin.

[numarrays length]=size(A);
arrays=zeros(numarrays*length,length);
arrays(1:numarrays,:)=A;
for i=1:length-1
   A=[A(:,2:end) A(:,1)];
   arrays(numarrays*i+1:(numarrays*i)+numarrays,:)=A;
end
out=unique(arrays,'rows');