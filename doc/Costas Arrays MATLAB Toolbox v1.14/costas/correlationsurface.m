function out=correlationsurface(x,y)
%correlationsurface(x,y) generates the correlation surface for two arrays

%	Generates the correlation surface for two input arrays.
%	These can then be viewed using the mesh function.
%   Enter the same Costas array for x and y and use the mesh function to 
%   see the ideal auto-ambiguity property of Costas arrays.
%
%	Example
%   -------
%       x=[1 2 4 8 5 10 9 7 3 6];
%		surface=correlationsurface(x,x);
%       mesh(surface)

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin.

w = length(x);
x = x-min(x)+1; % make min(x)==1
y = y-min(y)+1; % make min(y)==1
h = max(x);
out = zeros(2*w-1,2*h-1);
off1 = w+1; off2=h+1;
for i=1:w
    for j=1:w
        i1 = i-j+off1-1;
        i2 = x(i)-y(j)+off2-1;
        out(i1,i2)=out(i1,i2)+1;
    end
end