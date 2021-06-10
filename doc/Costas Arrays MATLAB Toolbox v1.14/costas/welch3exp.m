function out = welch3exp(p,a)
%welch3exp(p,a) generates exponential W3 Welch array sequences

%	Generates exponential W3 Welch Costas array sequences from a prime p,
%   with optional primitive element a.
%   For this construction 2 must be primitive in GF(p).
%	These are W2 arrays with a = 2 & the upper left corner dot removed.
%
%	Examples
%   --------
%		welch3exp(5)
%       % Output is [2 1]
%
%		welch3exp(11,2)
%       % Output is [2 6 3 8 7 5 1 4]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.2
%	Copyright (c) 2009 by University College Dublin.

if p<=3
    error('minimum prime is 5')      % error if p is less than 5
end
if ~isprime(p)
    error('not a prime number');     % error if 'p' entered is not a prime
end
if (nargin==2)                       % error if a is not 2
    if a~=2
        error('construction requires a = 2');
    end
end                                  % error if 2 is not primitive in GF(p)
if ~ismember(2,primelem(p))  
    error(['2 is not primitive in GF(' num2str(p) ')']);
end
if (nargin == 1)
    a = 2;                           % assume a = 2 if not entered
end
out=crem('ul',welch2exp(p,a));       % remove the upper left corner dot
                                     % from W2 arrays                              