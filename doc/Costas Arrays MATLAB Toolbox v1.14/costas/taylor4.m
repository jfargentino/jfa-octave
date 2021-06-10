function out = taylor4(q,a)
%taylor4(p,n,a) generates T4 variant to Lempel arrays

%	Generates T4 arrays, Taylor variant to the Lempel construction where
%   q is the prime power, and primitive elements a.
%   When primitive element a satisfies a^2 + a^1 = 1, then dots at
%	(1,2) and (2,1) can be removed simulaneously from L2.
%
%	Examples
%   --------
%		taylor4(11)
%       % Output is [3 6 1 7 5 2 4]
%
%		taylor4(19,14)
%       % Output is [13 5 3 9 2 14 11 15 4 12 7 10 1 6 8]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.2
%	Copyright (c) 2008 by University College Dublin.

if IsNotAPrimePower(q)
    error('enter prime or prime powers only');
end
n=length(factor(q));
p=unique(factor(q));
pes=primelem(p^n);              % get primitive elements
all_pes=pes;
pes=RemoveUnwantedPrimitiveElements(pes,p,n);  % remove primitives not satisfying a^2 + a^1 = 1
if isempty(pes)
    out=[];
    return
end
if nargin==1
    arrays=lempel2(p^n,pes);
elseif nargin==2
    if IsNotPrimitive(a,all_pes)           % error if a entered not primitive
        error([num2str(a) ' not all primitive in GF(' num2str(p) '). Pick a from ' num2str(pes) '.']);
    end
    if IsNotPrimitive(a,pes)               % error if a entered not a^2 + a = 1
        error([num2str(a) '^2 + ' num2str(a) '^1 ~= 1. Pick a from ' num2str(pes)]);
    end
    arrays=lempel2(q,a);
end
out=unique(arrays(:,3:end)-2,'rows');

function out=IsNotAPrimePower(p)
% check if p is a prime power
out=length(unique(factor(p)))~=1;

function out=IsNotPrimitive(a,pes)
% check if a is primitive
out=~all(ismember(a,pes));

function out=RemoveUnwantedPrimitiveElements(pes,p,n)
% remove primitives not satisfying a^2 + a^1 = 1
if n==1
    out=pes(mod(pes.^2+pes,p^n)==1);
else
    num_pes=size(pes,1);
    check=false(num_pes,1);
    irr=fliplr(gfprimfd(n,'min',p));
    one=[zeros(1,2*size(pes,2)-2) 1];
    for i=1:num_pes
        a=pes(i,:);
        test=mod(conv(a,a)+[zeros(1,n-1) a],p);
        [q,r]=deconv(test,irr);
        if all(mod(r,p)==one);
            check(i)=1;
        end
    end
    out=pes(check,:);
end