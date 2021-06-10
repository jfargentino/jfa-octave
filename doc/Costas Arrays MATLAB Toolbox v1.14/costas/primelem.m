function out=primelem(p)
%primelem(p) generates primitive elements for a p or q

%	Generates the primitive elements for an input prime p, or power of prime q.
%	These can be used in Costas array constructions such as Golomb & Welch.
%   For prime numbers the function outputs a vector of elements.
%   For prime powers the function outputs rows of polynomials,
%   which express decreasing powers of x.
%
%	Examples
%   --------
%		primelem(5)
%       % Output is [2 3]
%
%		primelem(9)
%       % Output is [1 0;2 2;2 0;1 1]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin.

if IsNotAPrimePower(p)              % error if not prime or prime power
    error('not a prime or power of a prime')
end

if isprime(p)                       % case for prime numbers
    pe=FindFirstPrimitiveElement(p);
    out=PrimitivesElementsForPrime(p,pe);
else                                % case for prime powers
    n=length(factor(p));            % obtain n from value entered
    p=unique(factor(p));            % obtain p from value entered
    q=p^n;                          % rename original p to q for clarity
    nm1=n-1;                        % set n-1 as it's used repeatedly
    irr=fliplr(gfprimfd(n,'min',p));% get irreducible polynomials
    x=[zeros(1,n-2) 1 0];           % i.e. if n=2 x = [1 0]                    
    ph=round((q-1)*prod(1-1./unique(factor(q-1))));   % Eulers totient (phi) function
    pr=GenerateXTable(q,x,irr,nm1,p,n);
    out=PrimitiveElementsForPrimePower(ph,n,x,q,pr);
end

function out=IsNotAPrimePower(p)
% check if p is a prime power
out=length(unique(factor(p)))~=1;

function num=FindFirstPrimitiveElement(p)
% find the first element which is primitive in GF(p)
for num=2:p-1,
    test=num;                   % set number to be tested
    for i=1:((p-1)/2),
        test=mod(num*test,p);   % raise the number to successive powers
        if test==1;             % if it becomes 1 before a full cycle
            break;              % then it is not primitive
        end                     % so break and test next number
    end
    if test~=1                  % if test never takes value 1 then
        break;                  % we have found the 1st primitive
    end                         % element, so move on
end

function out=PrimitivesElementsForPrime(p,pe)
% obtain all primitive elements from first primitive element
c=zeros(1,p-1);                 % allocate space for the primitives
c(1)=pe;                        % first primitive is the one from above
for i = 2:p-1                   %
    c(i) = mod(pe*c(i-1),p);    % take successive powers to get others
end                             % gcd finds index of primitives
out=unique(sort(c(gcd(1:p-2,p-1)==1))); 

function pr=GenerateXTable(q,x,irr,nm1,p,n)
% generate the table for x
pr=zeros(q-2,n);                % allocate space for x table
pr(1,:)=x;
for i=2:q-2
    [u v]=deconv(conv(pr(i-1,:),x),irr);% raise to next power and
    vl=length(v);                       % express in wanted terms
    v=v(vl-nm1:vl);
    pr(i,:)=mod(v,p);
end

function prim=PrimitiveElementsForPrimePower(ph,n,x,q,pr)
% find the primitive elements
prim=zeros(ph,n);               % allocate space for the primitives
prim(1,:)=x;                    % x is always primitive
count=2;                        % counter for primitives
for i=2:q-2
    if (gcd(i,q-1)==1)          % check each row and add to
        prim(count,:)=pr(i,:);  % list if primitive
        count=count+1;          % update counter if 1 is found
    end
end