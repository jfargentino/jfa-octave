function out=stubtocostas(v,n)
%stubtocostas(v,n) searches for arrays beginning with a stub

%	Searches exhaustively for Costas arrays which begin with a certain stub v,
%	 and are of a certain length n.
%	
%	Examples
%   --------
%		stubtocostas([1 2],4)
%       % Output is [1 2 4 3]
%
%		stubtocostas([1 5],5)
%       % Output is [1 5 4 2 3;1 5 3 2 4]		

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin.

ends=perms(setdiff(1:n,v));
num=size(ends,1);
results=[v(ones(num,1),:) ends];
out=results(iscostas(results),:);