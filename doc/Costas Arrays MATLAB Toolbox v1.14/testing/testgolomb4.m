function out = testgolomb4
%testgolomb4 determines if golomb4.m is working correctly

%	Tests the golomb4 generation function by comparing the arrays which it
%	generates to arrays which are loaded from files. If the function does
%	not generate the correct arrays then the result for each order is
%	displayed.

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin.

test_range=[8 16 32];
check=false(size(test_range));
i=1;
for p=test_range
    generated=minimal(golomb4(p));
    loaded=load(['c' sprintf('%.2d',p-4) '_G4uni.out']);
    check(i)=isequal(generated,loaded);
    i=i+1;
end
out=all(check);
if out==false
    disp(test_range)
    disp(check)
end