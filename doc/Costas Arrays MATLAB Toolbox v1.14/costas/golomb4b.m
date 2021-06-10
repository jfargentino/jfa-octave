function out = golomb4b(q,a,b)
%golomb4b(q,a,b) generates G4b Golomb array sequences

%	Generates G4b Golomb Costas array sequences from a prime power q,
%   with optional prime power n, optional primitive elements a and b.
%   These are G2 arrays with dots from (1,1) and (2,q-2) removed.
%   which can be done when a + b = 1, and a^2 + b^-1 = 1.
%   If G2 arrays are already known then they can be passed straight into
%   the function to obtain G4b arrays.
%
%	Examples
%   --------
%		golomb4b(41)
%       % Output is [37 23 27 10 7 2 20 25 16 32 21 1 18 29 35 ...]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.2
%	Copyright (c) 2009 by University College Dublin.

if size(q,2)~=1     % case for G2 arrays already known.
    out=crem('ur',crem('ul',q));
    return
end
n=length(factor(q));             % get value for n
p=unique(factor(q));             % get value for p
if IsNotAPrimePower(p^n)                   % error if not prime power
    error('enter prime or prime power');
end
if (nargin == 1)
    arrays=golomb3(p^n);                  % generate the G3 arrays
elseif (nargin == 2)
    if length(a)~=n
        error('a must be of length n');  % error if primitive a is not the right length
    end
    pes=primelem(p^n);      % generate primitive elements
    if all(a==1)
        a=pes;
    elseif n==1
        if IsNotPrimitive1(a,pes)        % error if a's entered not primitive
            disp([mat2str(a) ' not all primitive in GF(' num2str(p) '). Pick a from ' mat2str(pes) '.']);
        end
    else
        if IsNotPrimitive2(a,pes)        % error if a's entered not primitive
            error([mat2str(a) ' not all primitive in GF(' num2str(p) '). Pick a from ' mat2str(pes) '.']);
        end
    end
    arrays=golomb3(p^n,a);                % generate the G3 arrays
elseif (nargin == 3)
    if (length(a)~=n)||(length(b)~=n)
        error('a and b must be of length n'); % error if primitive a is not the right length
    end
    prim=primelem(p^n);
    if n==1
        if IsNotPrimitive1([a b],prim)            % error if a's entered not primitive
            disp([mat2str([a b]) ' not all primitive in GF(' num2str(p) '). Pick a from ' mat2str(prim) '.']);
        end
    elseif IsNotPrimitive2([a;b],prim)    % error if a's entered not primitive
        error([mat2str([a;b]) ' not all primitive in GF(' num2str(p) '). Pick a from ' mat2str(prim) '.']);
    end
    arrays=golomb3(p^n,a,b);                   % generate the G3 arrays
end
check=arrays(:,end)==1;
out=crem('ur',arrays(check,:));

function out=IsNotAPrimePower(p)
% check if p is a prime power
out=length(unique(factor(p)))~=1;

function out=IsNotPrimitive1(a,pes)
% check if a is primitive for n=1
out=~all(ismember(a,pes));

function out=IsNotPrimitive2(a,pes)
% check if a is primitive for n~=1
out=~all(ismember(a,pes,'rows'));