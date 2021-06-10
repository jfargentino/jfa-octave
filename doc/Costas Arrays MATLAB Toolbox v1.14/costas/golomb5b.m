function out = golomb5b(q,a,b)
%golomb5b(p,n,a,b) generates G5b Golomb array sequences

%	Generates G5b Golomb Costas array sequences from a prime power q,
%   with optional prime power n, optional primitive elements a and b.
%   These are G2 arrays with dots from (1,1),(2,q-2) and (q-2,2) removed.
%   which can be done when a + b = 1, and a^2 + b^-1 = 1.
%   If G2 arrays are already known then they can be passed straight into
%   the function to obtain G5b arrays.
%
%	Examples
%   --------
%		golomb5b(41)
%       % Output is [23 27 10 7 2 20 25 16 32 21 1 18 29 35 5 ...]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.2
%	Copyright (c) 2009 by University College Dublin.

if size(q,2)~=1     % case for G2 arrays already known.
    out=crem('ll',crem('ur',crem('ul',q)));
    return
end
n=length(factor(q));             % get value for n
p=unique(factor(q));             % get value for p
if (nargin == 1)
    if IsNotAPrimePower(p)         % error if p is not 2
        error('enter prime or prime power');
    end
    arrays=golomb4b(p^n);                   % generate the G4b arrays
end

if (nargin == 2)
    if length(a)~=n
        error('a must be of length n');  % error if primitive a is not the right length
    end
    pes=primelem(p^n);        % generate primitive elements
    if all(a==1)
        a=pes;
    elseif n==1
        if IsNotPrimitive1(a,pes)          % error if a's entered not primitive
            error([mat2str(a) ' not all primitive in GF(' num2str(p) '). Pick a from ' mat2str(pes) '.']);
        end
    else
        if IsNotPrimitive2(a,pes)       % error if a's entered not primitive
            error([mat2str(a) ' not all primitive in GF(' num2str(p) '). Pick a from ' mat2str(pes) '.']);
        end
    end
    arrays=golomb4b(p^n,a);                   % generate the G4b arrays
elseif (nargin == 3)
    if (length(a)~=n)||(length(b)~=n)
        error('a and b must be of length n');    % error if primitive a is not the right length
    end
    pes=primelem(p^n);            % generate primitive elements
    if n==1
        if IsNotPrimitive1([a b],pes)           % error if a's entered not primitive
            error([mat2str([a b]) ' not all primitive in GF(' num2str(p) '). Pick a from ' mat2str(pes) '.']);
        end
    else
        if IsNotPrimitive2([a;b],pes)     % error if a's entered not primitive
            disp([mat2str([a;b]) ' not all primitive in GF(' num2str(p) '). Pick a from ' mat2str(pes) '.']);
        end
    end
    arrays=golomb4b(p^n,a,b);                  % generate the G4b arrays
end
if size(arrays,1)<1
    out=[];
    return
end
check=arrays(:,1)==max(arrays(:));
out=crem('ll',arrays(check,:));

function out=IsNotAPrimePower(p)
% check if p is a prime power
out=length(unique(factor(p)))~=1;

function out=IsNotPrimitive1(a,pes)
% check if a is primitive for n=1
out=~all(ismember(a,pes));

function out=IsNotPrimitive2(a,pes)
% check if a is primitive for n~=1
out=~all(ismember(a,pes,'rows'));