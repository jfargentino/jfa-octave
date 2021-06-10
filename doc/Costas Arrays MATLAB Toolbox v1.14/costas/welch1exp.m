function out = welch1exp(p,a,c)
%welch1exp(p,a,c) generates exponential W1 Welch array sequences

%	Generates exponential W1 Welch Costas array sequences from a prime p,
%   with optional primitive elements a (1 = all), optional circular shift c.
%	Arrays begin with 1.
%
%	Examples
%   --------
%		welch1exp(3)
%       % Output is [1 2]
%
%		welch1exp(5,3)
%       % Output is [1 3 4 2]
%
%       welch1exp(7,5,1)
%       % Output is [5 4 6 2 3 1]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.11
%	Copyright (c) 2008 by University College Dublin.

if p==2                                         % if p is 2 output 1
    arrays=1;
elseif ~isprime(p)
    error('not a prime number');                % error if 'p' entered is not a prime
else
    if (nargin > 1)&&(all(a~=1))
        pes = primelem(p);
        if IsNotPrimitive(a,pes)                % error if a's entered not primitive
            error([num2str(a) ' not all primitive in GF(' num2str(p) '). Pick a from ' num2str(pes) '.']);
        end
    end
    if (nargin == 2)
        c = 0;                                  % assume circular shift c = 0 if not entered
    elseif (nargin == 1)
        a = primelem(p);               % take all primitive elements if not specified
        c = 0;                                  % c must take value 0 in this case
    end
    if a==1
        a = primelem(p);               % if a=1 include
    end                                         % all primitives
    arrays=GenerateFromPrimitives(a,p);
    if c~=0                                     % circular shift arrays as required
        arrays=CircularShiftArrays(c,arrays);
    end
end
out=sortrows(arrays);                           % sorts arrays

function out=IsNotPrimitive(a,pes)
% check if a is primitive
out=~all(ismember(a,pes));

function arrays=GenerateFromPrimitives(a,p)
% generate the W1 arrays from the primitive elements
arrays=zeros(length(a), p-1);               % allocate space for the arrays
arrays(:,1)=1;                              % all arrays begin with a 1
for j=1:length(a)                           % loop through for each primitive element
    pe=a(j);                            % set current primitive element
    for i=1:p-2                         % determine each element from the last
        arrays(j,i+1)=mod(pe*arrays(j,i),p);
    end
end

function arrays=CircularShiftArrays(c,arrays)
% circular shift the arrays by c elements
for k=1:c
    arrays=[arrays(:,2:end) arrays(:,1)];
end