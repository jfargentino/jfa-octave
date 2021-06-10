function out = golomb3(q,a,b)
%gen_G3(p,a,b) generates G3 Golomb array sequences

%	Generates G3 Golomb Costas array sequences from a prime power q,
%   with optional prime power n, optional primitive elements a and b.
%   These are G2 arrays with the upper left corner dot removed,
%   which can be done when a + b = 1.
%   If G2 arrays are already known then they can be passed straight into
%   the function to obtain G3 arrays.
%
%	Examples
%   --------
%		golomb3(7)
%       % Output is [2 3 1 4]
%
%		golomb3(17,6)
%       % Output is [7 10 12 2 14 11 5 6 4 3 8 1 9 13]
%
%       golomb3(17,7,11)
%       % Output is [6 9 14 12 13 8 1 5 7 3 2 10 4 11]
%
%       golomb3([1 3 4 2 5])
%       % Output is [2 3 1 4]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.2
%	Copyright (c) 2009 by University College Dublin.

if size(q,2)~=1     % case for G2 arrays already known.
    out=cremul(q);
    return
end
n=length(factor(q));             % get value for n
p=unique(factor(q));             % get value for p
if IsNotAPrimePower(p^n)         % error if not prime power
    error('enter prime or prime power');
end
if nargin==1
    arrays=golomb2(p^n);           % generate the G2 arrays
elseif nargin==2
    if (n==1)
        pes=primelem(p);           % get primitive elements
        if IsNotPrimitive1(a,pes)
            error([num2str(a) ' not all primitive in GF(' num2str(p) '). Pick a from ' num2str(pes) '.']);
            return;                             % error if a's entered not primitive
        end
    else
        q=p^n;
        prim=primelem(q);
        if all(a==1)
            a=prim;
        elseif IsNotPrimitive2(a,prim)
            error([mat2str(a) ' not all primitive in GF(' num2str(p) '). Pick a from ' mat2str(prim) '.']);
            return;                             % error if a's entered not primitive
        end
    end
    arrays=golomb2(p^n,a);
elseif nargin==3
    if (isprime(p^n))&&(n==1)
        pes=primelem(p);
        if IsNotPrimitive1(a,pes)||IsNotPrimitive1(b,pes)
            error([num2str([a b]) ' not all primitive in GF(' num2str(p) '). Pick a from ' num2str(pes) '.']);
            return
        end
    else
        if length(a)~=n||length(b)~=n
            error('a and b must be of length n');  % error if primitive a is not the right length
        end
        prim=primelem(p^n);
        if IsNotPrimitive2([a;b],prim)
            error([mat2str([a;b]) ' not all primitive in GF(' num2str(p) '). Pick a from ' mat2str(prim) '.']);
            return;                             % error if a's entered not primitive
        end
    end
    arrays=golomb2(p^n,a,b);
end
check=arrays(:,1)==1;
out=crem('ul',arrays(check,:));

function out=IsNotAPrimePower(p)
% check if p is a prime power
out=length(unique(factor(p)))~=1;

function out=IsNotPrimitive1(a,pes)
% check if a is primitive for n=1
out=~all(ismember(a,pes));

function out=IsNotPrimitive2(a,pes)
% check if a is primitive for n~=1
out=~all(ismember(a,pes,'rows'));