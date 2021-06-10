function out = welch0(p,a,c)
%welch0(p,a,c) generates W0 Welch array sequences

%	Generates W0 Welch Costas array sequences from a prime p,
%   with optional primitive elements a (1 = all), optional circular shift c.
%   W1 Welch Costas arrays are generated then corner dots are added.
%   The resulting arrays are tested to see if they are Costas arrays.
%
%	Examples
%   --------
%		welch0(3)
%       % Output is [2 3 1;3 1 2]
%
%		welch0(5,2)
%       % Output is [2 3 5 4 1;5 1 2 4 3]
%
%       welch0(5,3,1)
%       % Output is [1 4 5 3 2;3 4 2 1 5]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.2
%	Copyright (c) 2009 by University College Dublin.

if p==2                                         % output for p = 2
    out=[1 2; 2 1];
elseif isprime(p)==0
    error('not a prime number');                % error if 'p' entered is not a prime
else
    if (nargin > 1)&&(all(a~=1))
        pes = primelem(p);
        if IsNotPrimitive(a,pes)                % error if 'a' entered is not a primitive element
            error([num2str(a) ' not all primitive in GF(' num2str(p) '). Pick a from ' num2str(pes) '.']);
        end
    end
    if (nargin == 2)
        c = 0;                                  % assume c = 0 if not entered
    elseif (nargin == 1)
        a = primelem(p);           % take all primitive elements if not specified
        c = 0;                                  % c must take value 0 in this case
    end
    if a==1
        a = primelem(p);           % if a=1 include all
    end                                         % primitives
    arrays=circshifts(welch1(p, a, c));      % start with the W1 arrays
    out=AddCornerDotsAndFindCostas(arrays);
end
out=unique(out,'rows');                         % sort arrays and remove multiples of an array

function out=IsNotPrimitive(a,pes)
% check if a is primitive
out=~all(ismember(a,pes));

function out=AddCornerDotsAndFindCostas(arrays)
% add dots at each of the corners and check if they are Costas arrays
[num len]=size(arrays);
results=zeros(num*4,len+1);
results(1:num,:)=cadd('ul',arrays);
results(num+1:2*num,:)=cadd('ur',arrays);
results((2*num)+1:3*num,:)=cadd('ll',arrays);
results((3*num)+1:end,:)=cadd('lr',arrays);
out=results(iscostas(results),:);