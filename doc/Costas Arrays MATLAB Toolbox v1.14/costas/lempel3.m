function out = lempel3(p,a)
%lempel3(p,n,a) generates L3 Lempel array sequences

%	Generates L3 Lempel Costas array sequences from a prime p,
%   with optional prime power n and optional primitive element a.
%	For an odd prime with 2 primitive in GF(q), dot at (1,1) is removed.
%
%	Examples
%   --------
%		lempel3(5)
%       % Output is [2 1]
%
%		lempel3(11,6)
%       % Output is [3 5 1 8 2 7 6 4]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.2
%	Copyright (c) 2009 by University College Dublin.

n=length(factor(p));
if n~=1
    error('n must be 1 for this construction')
end
p=unique(factor(p));
if isequal(p,2)
    error('construction requires an odd prime');
elseif (isprime(p))
    if IsNotPrimitive(2,primelem(p))
        error(['2 is not primitive in GF(' num2str(p) ')']);
    end
end
if (nargin==1)
    arrays=lempel2(p);
end
if (nargin==2)
    arrays=lempel2(p,a);
end
out=crem('ul',arrays);

function out=IsNotPrimitive(a,pes)
% check if a is primitive
out=~ismember(a,pes);