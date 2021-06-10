function out=drt(x,n)
%shannon(x,n) searches for DRT arrays of size n using stub x.

%	Function takes a stub x and searches for Costas arrays of size n using
%	the DRT (Drakakis,Rickard,Taylor) array Construction method. 
%   (length(x)>2) Also works for more than one stub.
%
%	Examples
%   --------
%		drt([1 2],3)
%       % Output is [1 3 2]
%
%		drt([1 3 2],4)
%       % Output is [1 2 4 3;1 3 4 2]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.2
%	Copyright (c) 2008 by University College Dublin.

[xcols xlength]=size(x);
fid = fopen('drttemp2.out', 'wt');
for j=1:xcols
    shifts=GenerateAllShifts(x,j,xlength);
    for k=1:size(shifts,1)
        for l=0:n
            shifts(k,:)=mod(shifts(k,:)-1,xlength+1);
            shifts(k,shifts(k,:)==0)=NaN;
            created=PlaceInFrame(shifts(k,:),n);
            for m=1:size(created,1)
                fprintf(fid, '%d ', created(m,:));
                fprintf(fid, '\n');
            end
            shifts(k,isnan(shifts(k,:)))=0;
        end
    end
end
fclose(fid);
out=load('drttemp2.out');
out=unique(out,'rows');
delete drttemp1.out
delete drttemp2.out

function out = GenerateAllShifts(x,j,xlength)
% generate all the shifts for placing in frames
shifts=zeros(xlength);
y=[x(j,:) NaN];
shifts(1,:)=y(1:end-1);
for i=2:xlength+1
    y=[y(2:end) y(1)];
    z=y(1:end-1);
    z=z-min(z)+1;
    shifts(i,:)=z;
end
out=shifts;

function out=PlaceInFrame(x,n)
% generate all the possible frames
xlength=length(x);
x=x-min(x)+1;
a=n-max(x)+1;
b=n-xlength+1;
arrays=zeros((a)*(b),n);
for i=0:n-xlength
    j=1;
    y=x;
    before=zeros(1,i);
    before(1,:)=NaN;
    after=zeros(1,n-xlength-i);
    after(1,:)=NaN;
    while max(y)<=n
        arrays((i*a)+j,:)=[before y after];
        y=y+1;
        j=j+1;
    end
end
fid = fopen('drttemp1.out', 'wt');
for i= 1:a*b
    created=CompleteFrame(arrays(i,:));
    for j=1:size(created,1)
        fprintf(fid, '%d ', created(j,:));
        fprintf(fid, '\n');
    end
end
fclose(fid);
out=load('drttemp1.out');
out=unique(out,'rows');

function out=CompleteFrame(x)
% fill in the frames and test for Costas
numnans=sum(isnan(x));
numcols=factorial(numnans);
xlength=length(x);
fillings=perms(setdiff(1:xlength,x));
creations=zeros(numcols,xlength);
nanindex=find(isnan(x));
for i=1:numcols
    creations(i,:)=x;
    j=1;
    for filler=nanindex
        creations(i,filler)=fillings(i,j);
        j=j+1;
    end
end
found=creations(iscostas(creations),:);
out=minimal(found);