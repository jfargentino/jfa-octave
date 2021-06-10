function out = golomb2(q,a,b)
%golomb2(q,a,b) generates G2 Golomb array sequences

%	Generates G2 Golomb Costas array sequences from a prime power q,
%   with optional prime power n, optional primitive elements a and b.
%   Setting a=1 takes all primitive elements
%
%	Examples
%   --------
%		golomb2(5)
%       % Output is [2 3 1]
%
%		golomb2(7,3)
%       % Output is [1 3 4 2 5]
%
%       golomb2(11,2,6)
%       % Output is [5 7 8 3 9 2 6 4 1]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.2
%	Copyright (c) 2008 by University College Dublin.

if IsNotAPrimePower(q)
    error('enter prime number or prime power');  % error if not prime or prime power
end
    n=length(factor(q));             % get value for n
    p=unique(factor(q));             % get value for p

if (isprime(p^n))&&(nargin == 1) % case for p prime
    
        if p<5
            error('minimum p is 5');         % error for p less than 5
        else
            arrays=GenerationForPrime(p);
        end
        out=unique(arrays,'rows');                  % sort arrays
        return;
end
if (nargin == 1)
    q=p^n;                          % set q value for clarity
    nm1=n-1;                        % set n-1 for repeated use
    irr=fliplr(gfprimfd(n,'min',p));% obtain irreducible polynomials
    x=[zeros(1,n-2) 1 0];           % set x
    ppows=GeneratePrimePowers(nm1,n,p);
    ph=round((q-1)*prod(1-1./unique(factor(q-1))));   % Eulers totient (phi) function
    pr=GenerateXTable(q,n,x,irr,nm1,p);
    prim=FindPrimitiveElements(ph,n,x,q,pr);
    logt=BuildLogTables(q,n,ph,pr,prim,irr,nm1,p);
    arrays=GenerationForPrimePower(ph,n,q,logt,p,ppows);
    out=sortrows(arrays);
end
if (nargin == 2)            % case for prime power and primitive element
    if (isprime(p^n))                           % if n is one
        pes=primelem(p);           % get primitive elements
        if a==1
            a=pes;
        elseif IsNotPrimitive1(a,pes)           % error if a's entered not primitive
            error([num2str(a) ' not all primitive in GF(' num2str(p) '). Pick a from ' num2str(pes) '.']);
        end
        arrays=GenerationForPrimeWithA(p,a,pes);
        out=unique(arrays,'rows');  % sort arrays
        return;
    end
    q=p^n;
    nm1=n-1;
    irr=fliplr(gfprimfd(n,'min',p));
    x=[zeros(1,n-2) 1 0];
    ph=round((q-1)*prod(1-1./unique(factor(q-1))));   % Eulers totient (phi) function
    pr=GenerateXTable(q,n,x,irr,nm1,p);
    prim=FindPrimitiveElements(ph,n,x,q,pr);
    if all(a==1)
        a=prim;
    elseif IsNotPrimitive2(a,prim)          % error if a's entered not primitive
        error([mat2str(a) ' not all primitive in GF(' num2str(q) '). Pick a from ' mat2str(prim) '.']);
    end
    [logt all_first]=BuildLogTablesForASpecified(a,q,n,ph,pr,prim,irr,nm1,p);
    arrays=GenerationForPrimePowerWithA(n,all_first,ph,q,logt,p);
    out=unique(arrays,'rows');
end
if (nargin == 3)    % case for both primitives specified
    if (isprime(p^n))
        pes=primelem(p);
        if (IsNotPrimitive1(a,pes))||(IsNotPrimitive1(b,pes))
            error([num2str([a b]) ' not all primitive in GF(' num2str(p) '). Pick a from ' num2str(pes) '.']);
        end
        arrays=GenerationForPrimeWithAandBspecified(p,a,b);
        out=unique(arrays,'rows');
        return;
    end
    q=p^n;
    irr=fliplr(gfprimfd(n,'min',p));
    prim=primelem(q);
    if IsNotPrimitive2([a;b],prim)      % error if a's entered not primitive
        error([mat2str([a;b]) ' not all primitive in GF(' num2str(q) '). Pick a from ' mat2str(prim) '.']);
    end
    prim=[a;b];
    [first second]=BuildLogTablesForAandBSpecified(q,n,prim,irr,p);
    out=GenerationForPrimePowerWithAandBspecified(q,n,first,second,p);
end

function out=IsNotAPrimePower(p)
% check if p is a prime power
out=length(unique(factor(p)))~=1;

function arrays=GenerationForPrime(p)
% case for a prime entered
j=1;                         % counter for arrays
beta=zeros(1,p-1);           % allocate space for powers of b
pes=primelem(p);    % get the primitive elements
arrays=zeros(length(pes)*(length(pes)-1)/2,p-2); % space for arrays
for a=1:length(pes)
    for b=a:length(pes)   % loop thru pairs of primitive elements
        beta(1)=pes(b);     % first power of beta
        alpha=1;            % start with alpha as 1
        for i=1:p-2
            beta(i+1)=mod(pes(b)*beta(i),p); % get successive powers
        end                                  % of beta
        for i=1:p-2
            alpha=mod(alpha*pes(a),p);  % get next power of alpha
            gamma=mod(1-alpha,p);       % get 1 - alpha
            arrays(j,i)=find(gamma==beta);  % find where this = beta
        end
        j=j+1;                          % move on to next array
    end
end

function ppows=GeneratePrimePowers(nm1,n,p)
% generate the powers of p
ppows=zeros(nm1,1);
ppows(1)=1;
for i=2:n
    ppows(i)=p*ppows(i-1);
end

function pr=GenerateXTable(q,n,x,irr,nm1,p)
% generate the table for x
pr=zeros(q-2,n);                % allocate space for powers of x
pr(1,:)=x;                      % set first power
for i=2:q-2
    [u v]=deconv(conv(pr(i-1,:),x),irr);    % raise to next power and
    vl=length(v);                           % express in wanted terms
    v=v(vl-nm1:vl);
    pr(i,:)=mod(v,p);
end

function prim=FindPrimitiveElements(ph,n,x,q,pr)
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

function logt=BuildLogTables(q,n,ph,pr,prim,irr,nm1,p)
% Build the log tables
logt=zeros(q-2,n,ph);         % allocate space for a table for each ph
logt(:,:,1)=pr;               % set the first splice (table)
for i=2:ph
    aux=zeros(q-2,n);         % allocate space for the current table
    prc=prim(i,:);            % get primitive element for this table
    aux(1,:)=prc;             % set the first table element
    for j=2:q-2
        [u v]=deconv(conv(aux(j-1,:),prc),irr);%
        vl=length(v);                       % raise to next power and
        v=v(vl-nm1:vl);                     % express in wanted terms
        aux(j,:)=mod(v,p);                  % to get table
    end
    logt(:,:,i)=aux;            % set this splice into the table
end

function arrays=GenerationForPrimePower(ph,n,q,logt,p,ppows)

one=[zeros(1,n-1) 1];           % - set 1
arrays=zeros(ph*ph/n,q-2);      % allocate space for created arrays
count=1;                        % counter for arrays
forb=zeros(0,2*n);              % forbidden combinations that lead to duplicates if considered!
for k=1:ph
    %First do the symmetric case
    if (~ismember([logt(1,:,k) logt(1,:,k)],forb,'rows'))
        first=logt(:,:,k);      % set the first primitive table
        second=logt(:,:,k);     % set the second primitive table
        for i=1:q-2
            aux=mod(one-first(i,:),p);
            arrays(count,i)=find(ismember(second,aux,'rows'));
        end             % find where one minus the 1st equals the 2nd
        count=count+1;  % move onto the next array
        forb=union([first(ppows,:) second(ppows,:)],forb,'rows');
    end
    % Now do the rest
    for l=k+1:ph % Cases l<k will be treated by transposition
        if (~ismember([logt(1,:,k) logt(1,:,l)],forb,'rows'))
            first=logt(:,:,k);      % set the first primitive table
            second=logt(:,:,l);     % set the second primitive table
            for i=1:q-2
                aux=mod(one-first(i,:),p);
                arrays(count,i)=find(ismember(second,aux,'rows'));
            end             % find where one minus the 1st equals the 2nd
            forb=union([first(ppows,:) second(ppows,:)],forb,'rows');
            count=count+1;
            if (~ismember([logt(1,:,l) logt(1,:,k)],forb,'rows'))
                [junk,aux]=sort(arrays(count-1,:),2); % Find the transpose
                arrays(count,:)=aux; % Append it to the results
                count=count+1;  % move onto the next array
                forb=union([second(ppows,:) first(ppows,:)],forb,'rows');
            end
        end
    end
end

function out=IsNotPrimitive1(a,pes)
% check if a is primitive for n=1
out=~all(ismember(a,pes));

function out=IsNotPrimitive2(a,pes)
% check if a is primitive for n~=1
out=~all(ismember(a,pes,'rows'));

function arrays=GenerationForPrimeWithA(p,a,pes)
% generate arrays with a specified primitive element
j=1;                                % array counter
beta=zeros(1,p-1);                  % allocate space for beta
a_count=size(a,2);
arrays=zeros((length(pes)-1)*a_count,p-2);    % allocate space for arrays
for k=1:a_count
    for b=1:length(pes)                 % loop through each other
        if pes(b)~=a(k)                    % primitive besides a
            beta(1)=pes(b);             % set first beta value
            alpha=1;                    % start with alpha = 1
            for i=1:p-2
                beta(i+1)=mod(pes(b)*beta(i),p);
            end                      % get successive powers of beta
            for i=1:p-2
                alpha=mod(alpha*a(k),p);       % get next power of alpha
                gamma=mod(1-alpha,p);       % get 1 - alpha
                arrays(j,i)=find(gamma==beta); % find where this = beta
            end
            j=j+1;          % move on to next array
        end
    end
end

function [logt all_first]=BuildLogTablesForASpecified(a,q,n,ph,pr,prim,irr,nm1,p)
% Build the log tables for when a is given a specific value
ind=find(ismember(prim,a,'rows'));
all_first=[];
first=pr;
all_first(:,:,1)=first;
first_count=1;
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
    if ismember(i,ind)
        all_first(:,:,first_count)=aux;
        first_count=first_count+1;
    end
    logt(:,:,i)=aux;
end

function arrays=GenerationForPrimePowerWithA(n,all_first,ph,q,logt,p)
% generate arrays when a has a specific value
one=[zeros(1,n-1) 1];
a_count=size(all_first,3);
arrays=zeros(ph*a_count,q-2);
count=1;
for k=1:a_count
    first=all_first(:,:,k);
    for l=1:ph
        second=logt(:,:,l);
        for i=1:q-2
            aux=mod(one-first(i,:),p);
            arrays(count,i)=find(ismember(second,aux,'rows'));
        end
        count=count+1;
    end
end

function arrays=GenerationForPrimeWithAandBspecified(p,a,b)
% generate arrays which a and b have specific values
beta=zeros(1,p-1);
arrays=zeros(1,p-2);
beta(1)=b;
alpha=1;
for i=1:p-2
    beta(i+1)=mod(b*beta(i),p);
end
for i=1:p-2
    alpha=mod(alpha*a,p);
    gamma=mod(1-alpha,p);
    arrays(i)=find(gamma==beta);
end

function [first second]=BuildLogTablesForAandBSpecified(q,n,prim,irr,p)
% Build the log tables for a and b
nm1=n-1;
first=zeros(q-2,n);
for i=1:2
    aux=zeros(q-2,n);
    prc=prim(i,:);
    aux(1,:)=prc;
    for j=2:q-2
        [u v]=deconv(conv(aux(j-1,:),prc),irr);
        vl=length(v);
        v=v(vl-nm1:vl);
        aux(j,:)=mod(v,p);
    end
    if i==1
        first=aux;
    end
end
second=aux;

function array=GenerationForPrimePowerWithAandBspecified(q,n,first,second,p)

array=zeros(1,q-2);
one=[zeros(1,n-1) 1];
for i=1:q-2
    aux=mod(one-first(i,:),p);
    array(i)=find(ismember(second,aux,'rows'));
end