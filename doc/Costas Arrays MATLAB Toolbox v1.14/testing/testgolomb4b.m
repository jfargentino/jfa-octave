function out = testgolomb4b
%testgolomb4b determines if golomb4b.m is working correctly

%	Tests the golomb4b generation function by comparing the arrays which it
%	generates to arrays which are loaded from files. If the function does
%	not generate the correct arrays then the result for each order is
%	displayed.

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin.

test_range=5:31;
i=1;
for p=test_range
    if length(unique(factor(p)))~=1
        test_range(i)=NaN;
    end
    i=i+1;
end
test_range(isnan(test_range))=[];
check=false(size(test_range));
i=1;
for p=test_range
    generated=minimal(golomb4b(p));
    loaded=load(['c' sprintf('%.2d',p-4) '_G4buni.out']);
    check(i)=isequal(generated,loaded);
    i=i+1;
end
out=all(check);
if out==false
    disp(test_range)
    disp(check)
end