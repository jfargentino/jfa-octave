function out = golomb4(q,a,b)
%golomb4(q,a,b) generates G4 Golomb array sequences

%	Generates G4 Golomb Costas array sequences from a prime power q,
%   with optional prime power n, optional primitive elements a and b.
%   These are G2 arrays with dots from (1,1) and (2,2) removed.
%   which can be done when p=2, n>2, and a + b = 1.
%   If G2 arrays are already known then they can be passed straight into
%   the function to obtain G4 arrays.
%
%	Examples
%   --------
%		golomb4(8)
%       % Output is [3 2 4 1;4 2 1 3]
%
%		golomb4(2,4,[0 0 1 0])
%       % Output is [9 2 8 5 4 6 11 3 1 12 7 10]
%
%       golomb4(golomb2(8))
%       % Output is [3 2 4 1;4 2 1 3]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.2
%	Copyright (c) 2009 by University College Dublin.

if size(q,2)~=1     % case for G2 arrays already known.
    out=crem('ul',crem('ul',q));
    return
end
n=length(factor(q));             % get value for n
p=unique(factor(q));             % get value for p
if (isprime(p^n))
    if isNot2(p)         % error if p is not 2
        error('construction requires power of 2');
    end
    arrays=golomb3(p);                    % generate the G3 arrays
end
    if n<=2
        error('n must be 3 or greater'); % error for arrays of size <=4
    end
if (nargin == 1)
    arrays=golomb3(p^n);                  % generate the G3 arrays
elseif (nargin == 2)
    if length(a)~=n
        error('a must be of length n');  % error if primitive a is not the right length
    end
    prim=primelem(p^n);     % generate primitive elements
    if all(a==1)
        a=prim;
    elseif IsNotPrimitive(a,prim)         % error if a's entered not primitive
        error([mat2str(a) ' not all primitive in GF(' num2str(p) '). Pick a from ' mat2str(prim) '.']);                            
    end

    arrays=golomb3(p^n,a);                % generate the G3 arrays
elseif (nargin == 3)
    if length(a)~=n||length(b)~=n
        error('a and b must be of length n');  % error if primitive a is not the right length
    end
    prim=primelem(p^n);
    if IsNotPrimitive([a;b],prim)        % error if a's entered not primitive
        disp([mat2str([a;b]) ' not all primitive in GF(' num2str(p) '). Pick a from ' mat2str(prim) '.']);                            
    end

    arrays=golomb3(p^n,a,b);              % generate the G3 arrays
end
check=arrays(:,1)==1;
out=crem('ul',arrays(check,:));

function out=isNot2(p)
% determine if p is 2
out=~isequal(unique(factor(p)),2);

function out=IsNotPrimitive(a,pes)
% check if a is primitive
out=~all(ismember(a,pes,'rows'));