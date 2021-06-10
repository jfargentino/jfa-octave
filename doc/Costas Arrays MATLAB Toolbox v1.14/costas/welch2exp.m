function out = welch2exp(p,a)
%welch2exp(p,a) generates exponential W2 Welch array sequences

%	Generates exponential W2 Welch Costas array sequences from a prime p,
%   with optional primitive elements a (1 = all).
%	These are W1 arrays with the upper left corner dot removed.
%
%	Examples
%   --------
%		welch2exp(3)
%       % Output is [1]
%
%		welch2exp(5,3)
%       % Output is [2 3 1]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.2
%	Copyright (c) 2009 by University College Dublin.

if p==2                                         % if p is 2 output nothing
    out=[];
elseif p==3                                     % if p is 3 output 1
    out=1;
elseif ~isprime(p)
    error('not a prime number');                 % error if 'p' entered is not a prime
else
    if (nargin == 2)&&(all(a~=1))
        pes = primelem(p);
        if IsNotPrimitive(a,pes)  % error if 'a' entered is not a primitive element
            error([num2str(a) ' not all primitive in GF(' num2str(p) '). Pick a from ' num2str(pes) '.']);
        end
    else
        a = primelem(p);               % take all primitive elements if not specified
    end
    out = crem('ul',welch1exp(p,a));
end

function out=IsNotPrimitive(a,pes)
% check if a is primitive
out=~all(ismember(a,pes));