function out = rickard(x,n)
%rickard(x,n) searches for Rickard arrays of size n using stub x.

%	Starts with stub x and tries to obtain Costas arrays of size n by
%	placing an appropriate frame around the array and testing all possible
%	combinations of filling it in.
%
%	Examples
%   --------
%		rickard([1 2],3)
%       % Output is [1 3 2]
%
%		rickard([1 2],4)
%       % Output is [1 2 4 3;1 3 4 2]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin.

[xcols xlength]=size(x);
fid = fopen('ricktemp2.out', 'wt');
for j=1:xcols
    shifts=GenerateAllShifts(x,j,xlength);
    for i=1:size(shifts,1)
        created=PlaceInFrame(shifts(i,:),n);
        for k=1:size(created,1)
            fprintf(fid, '%d ', created(k,:));
            fprintf(fid, '\n');
        end
    end
end
fclose(fid);
out=load('ricktemp2.out');
out=unique(out,'rows');
delete ricktemp1.out
delete ricktemp2.out

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

function out = PlaceInFrame(x,n)
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
fid = fopen('ricktemp1.out', 'wt');
for i= 1:a*b
    created=CompleteFrame(arrays(i,:));
    for j=1:size(created,1)
        fprintf(fid, '%d ', created(j,:));
        fprintf(fid, '\n');
    end
end
fclose(fid);
out=load('ricktemp1.out');
out=unique(out,'rows');

function out = CompleteFrame(x)
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