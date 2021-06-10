function out = iscostas(A)
%iscostas(x) tests sequence to see if Costas condition is satisfied.

%	Tests sequence to see if it contains unique vectors between pairs of 
%   dots (does not test to see if sequence is permutation sequence).
%	(a NaN can be used for a blank column in the sequence)
%	Also tests multiple rows of sequences of the same length,
%	returning a column of 1's and 0's.
%	1 indicates condition is satisfied, 0 not satisfied.
%
%	Examples
%   --------
% 		iscostas([1 3 2])
%       % Output is [1]
%
%		iscostas([1 2 3;1 3 2]) 
%       % Output is [0;1]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin.

[num,len]=size(A);

conv2check=(exist('conv2','builtin')==5);
out = false(num,1);
for i = 1:num   
   if AllElementsAreUnique(A(i,:)) 
       out(i)=true;
   end
   j=0;
   runto = ceil(len/2)-1;
   while out(i) && (j<runto)
      if DtRowElementsAreUnique(A(i,:),j,len,conv2check)
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

function out=DtRowElementsAreUnique(row_i,j,len,conv2check)
% check difference triangle row for repeated values
if conv2check
    dt_row = conv2(row_i,[1 zeros(1,j) -1],'valid');
    out=length(unique(dt_row))==len-1-j;
else
    dt_row = conv(row_i,[1 zeros(1,j) -1]);
    out=length(unique(dt_row(2+j:end-1-j)))==len-1-j;
end
