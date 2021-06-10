function out = dsym(op,A)
%dsym(op,A) performs flip or rotation 'op' to array A

%   A function to obtain a flip or rotation of an array or 
%   multiple arrays in permutation form. options are:
%   'hor', 'ver', 'mdiag', 'adiag', 90, 180, 270.
%   The numbers represent degrees of clockwise rotation.
%
%	Examples
%   --------
%		dsym('hor',[1 3 2])
%       % Output is [3 1 2]
%
%		dsym(90,[4 1 3 2;1 2 4 3])
%       % Output is [1 3 4 2;3 4 2 1]

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.3
%	Copyright (c) 2009 by University College Dublin.

if strcmp('hor',op)
    [num,N]=size(A);        % get the size of the array(s)
    out=N-A+1;              % horizontal flip
elseif strcmp('ver',op)
    out=fliplr(A);          % vertical flip
elseif strcmp('mdiag',op)
    [junk,out]=sort(A,2);   % get the main diagonal flip
elseif strcmp('adiag',op)
    [num,N]=size(A);
    [junk,A1]=sort(A,2);    % get the main diagonal flip
    out=fliplr(N-A1+1);
elseif op==90
    [junk,A1]=sort(A,2);    % get the main diagonal flip
    out=fliplr(A1);          % 90 deg rotation is flip mdiag & ver
elseif op==180
    [num,N]=size(A);        % get the size of the array(s)
    out=fliplr(N-A+1);      % 180 deg rotation is flip hor & ver
elseif op==270
    [num,N]=size(A);        % get the size of the array(s)
    [junk,A1]=sort(A,2);    % get the main diagonal flip
    out=N-A1+1;             % 270 deg rotation is flip mdiag & ver
end