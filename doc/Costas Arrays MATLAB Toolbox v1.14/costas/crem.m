function out = crem(loc,A)
%crem(loc,A) removes a corner dot at location 'loc'

%   A function to removes a corner dot to corners of an array or 
%   multiple arrays in permutation form. Outputs minimal versions 
%   of all arrays regardless of whether or not the result is Costas.
%
%	Examples
%   --------
%		crem('ll',[4 2 1 3;4 1 3 2])
%       % Output is [2 1 3;1 3 2]
%
%		crem('ur',[2 4 3 1;3 2 4 1])
%       % Output is [1 3 2;2 1 3]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.3
%	Copyright (c) 2009 by University College Dublin.

if strcmp('ul',loc)
    A=A(A(:,1)==1,:);           % remove unwanted arrays
    if size(A,1)==0
        out=[];
        return
    end
    A(:,1)=[];
    out=A-1;
elseif strcmp('ur',loc)
    A=A(A(:,end)==1,:);     % remove unwanted arrays
    if size(A,1)==0
        out=[];
        return
    end
    A(:,end)=[];
    out=A-1;
elseif strcmp('ll',loc)
    A=A(A(:,1)==max(A,[],2),:); % remove unwanted arrays
    if size(A,1)==0
        out=[];
        return
    end
    out=A(:,2:end);
elseif strcmp('lr',loc)
    A=A(A(:,end)==max(A,[],2),:); % remove unwanted arrays
    if size(A,1)==0
        out=[];
        return
    end
    A(:,end)=[];
    out=A;
end