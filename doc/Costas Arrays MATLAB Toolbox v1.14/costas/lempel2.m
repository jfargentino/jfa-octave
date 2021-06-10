function out = lempel2(q,a)
%lempel2(q,n,a) generates L2 Lempel array sequences

%	Generates L2 Lempel Costas array sequences from a prime power q,
%   with optional prime power n, optional primitive element a.
%   Setting a=1 takes all primitive elements.
%
%	Examples
%   --------
%		lempel2(5)
%       % Output is [1 3 2;2 3 1]
%
%		lempel2(7,1,3)
%       % Output is [5 3 2 4 1]
%
%       lempel2(11,1,6)
%       % Output is [1 4 6 2 9 3 8 7 5]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.2
%	Copyright (c) 2008 by University College Dublin.

if IsNotAPrimePower(q)
    disp('enter prime number or prime power');
    return
end
n=length(factor(q));
p=unique(factor(q));
if (nargin == 1)&&(isprime(p^n))
        if p<5
            error('minimum p is 5');
        else
            arrays=GenerationForPrime(p);
        end
        out=unique(arrays,'rows');
elseif (nargin == 1)
    q=p^n;
    nm1=n-1;
    irr=fliplr(gfprimfd(n,'min',p));
    x=[zeros(1,n-2) 1 0];
    ph=round((q-1)*prod(1-1./unique(factor(q-1))));   % Eulers totient (phi) function
    pr=GenerateXTable(q,x,irr,nm1,p,n);
    prim=FindPrimitiveElements(ph,n,x,q,pr);
    logt=BuildLogTables(q,n,ph,pr,prim,irr,nm1,p);
    arrays=GenerationForPrimePower(ph,q,logt,p,n);
    out=unique(arrays,'rows');
end
if (nargin == 2)
    if isprime(p^n)
        pes=primelem(p);           % get primitive elements
        if a==1
            a=pes;
        elseif IsNotPrimitive1(a,pes)          % error if a's entered not primitive
            error([num2str(a) ' not all primitive in GF(' num2str(p) '). Pick a from ' num2str(pes) '.']);
        end
        arrays=GenerationForPrimeWithA(a,p);
        out=unique(arrays,'rows');
        return;
    end
    if size(a,2)~=n
        error('a must be of length n');
    end
    q=p^n;
    nm1=n-1;
    irr=fliplr(gfprimfd(n,'min',p));
    pes=primelem(q);
    if all(a==1)
        a=pes;
    elseif IsNotPrimitive2(a,pes)    % error if a's entered not primitive
        error([mat2str(a) ' not all primitive in GF(' num2str(p) '). Pick a from ' mat2str(pes) '.']);
    end
    out=GenerationForPrimePowerWithA(a,p,q,irr,nm1,n);
end

function out=IsNotAPrimePower(p)
% check if p is a prime power
out=length(unique(factor(p)))~=1;

function arrays=GenerationForPrime(p)
% generate all arrays from prime p
j=1;
pes=primelem(p);
arrays=zeros(length(pes),p-2);
alpha=zeros(1,p-1);
for a=1:length(pes)
    alpha(1)=pes(a);
    for i=1:p-2
        alpha(i+1)=mod(alpha(i)*pes(a),p);
    end
    for i=1:p-2
        gamma=mod(1-alpha(i),p);
        arrays(j,i)=find(gamma==alpha);
    end
    j=j+1;
end

function pr=GenerateXTable(q,x,irr,nm1,p,n)
% generate the table for x
pr=zeros(q-2,n);
pr(1,:)=x;
for i=2:q-2
    [u v]=deconv(conv(pr(i-1,:),x),irr);
    vl=length(v);
    v=v(vl-nm1:vl);
    pr(i,:)=mod(v,p);
end

function prim=FindPrimitiveElements(ph,n,x,q,pr)
% find the primitive elements
prim=zeros(ph,n);
prim(1,:)=x;
count=2;
for i=2:q-2
    if (gcd(i,q-1)==1)
        prim(count,:)=pr(i,:);
        count=count+1;
    end
end

function logt=BuildLogTables(q,n,ph,pr,prim,irr,nm1,p)
% Build the log tables
logt=zeros(q-2,n,ph);
logt(:,:,1)=pr;
for i=2:ph
    aux=zeros(q-2,n);
    prc=prim(i,:);
    aux(1,:)=prc;
    for j=2:q-2
        [u v]=deconv(conv(aux(j-1,:),prc),irr);
        vl=length(v);
        v=v(vl-nm1:vl);
        aux(j,:)=mod(v,p);
    end
    logt(:,:,i)=aux;
end

function arrays=GenerationForPrimePower(ph,q,logt,p,n)
% generate all arrays
one=[zeros(1,n-1) 1];
arrays=zeros(ph,q-2);
count=1;
for k=1:ph
    first=logt(:,:,k);
    for i=1:q-2
        aux=mod(one-first(i,:),p);
        arrays(count,i)=find(ismember(first,aux,'rows'));
    end
    count=count+1;
end

function out=IsNotPrimitive1(a,pes)
% check if a is primitive for n=1
out=~all(ismember(a,pes));

function out=IsNotPrimitive2(a,pes)
% check if a is primitive for n=1
out=~all(ismember(a,pes,'rows'));

function arrays=GenerationForPrimeWithA(a,p)
% generate arrays with specific a values
a_count=size(a,2);
j=1;
beta=zeros(1,p-1);
arrays=zeros(a_count,p-2);
for k=1:a_count
    beta(1)=a(k);
    alpha=1;
    for i=1:p-2
        beta(i+1)=mod(a(k)*beta(i),p);
    end
    for i=1:p-2
        alpha=mod(alpha*a(k),p);
        gamma=mod(1-alpha,p);
        arrays(j,i)=find(gamma==beta);
    end
    j=j+1;
end

function arrays=GenerationForPrimePowerWithA(a,p,q,irr,nm1,n)
% generate arrays with specific a values
one=[zeros(1,n-1) 1];
a_count=size(a,1);
arrays=zeros(a_count,p-2);
for k=1:a_count
    prim=a(k,:);
    % Build the log tables
    aux=zeros(q-2,n);
    aux(1,:)=prim;
    for j=2:q-2
        [u v]=deconv(conv(aux(j-1,:),prim),irr);
        vl=length(v);
        v=v(vl-nm1:vl);
        aux(j,:)=mod(v,p);
    end
    first=aux;
    for i=1:q-2
        aux=mod(one-first(i,:),p);
        arrays(k,i)=find(ismember(first,aux,'rows'));
    end
end