function out = iscostasperm(A)
%iscostasperm(A) tests sequence to see if both Costas conditions are 
%satisfied.

%	Tests sequence to see if it is a permutation and also contains unique
%	vectors between all pairs of dots.
%	Also tests multiple rows of sequences of the same length,
%	returning a column of 1's and 0's.
%	1 indicates conditions are satisfied, 0 not satisfied.
%
%	Examples
%   --------
% 		iscostasperm([1 3 2])
%       % Output is [1]
%
%		iscostasperm([1 2 3;1 3 2])
%       % Output is [0;1]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin.

[num,len]=size(A);

out = false(num,1);
for i = 1:num   
   if AllElementsAreUnique(A(i,:))
       out(i)=true;
   end
   if RowIsNotAPermutation(A(i,:))
      break 
   end
   j=0;   
   runto = ceil(len/2)-1;       % use Changs theorem for speed   
   while out(i) && (j<runto)    % construct difference triangle
      if DtRowElementsAreUnique(A(i,:),j)
          out(i)=true;
      else
          out(i)=false;
      end
      j = j+1;
   end
end

function out=AllElementsAreUnique(row_i)
% check for repeated values
out=length(unique(row_i))==length(row_i);

function out=RowIsNotAPermutation(row_i)
% check if row is a permutation
perm_test=diff(sort(row_i));
out=(any(perm_test)~=1)||(perm_test(1)~=1);

function out=DtRowElementsAreUnique(row_i,j)
% check difference triangle row for repeated values
dt_row = conv(row_i,[1 zeros(1,j) -1]);
out=length(unique(dt_row))==length(dt_row);