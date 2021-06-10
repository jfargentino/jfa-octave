function out = testlempel3
%testlempel3 determines if lempel3.m is working correctly

%	Tests the lempel3 generation function by comparing the arrays which it
%	generates to arrays which are loaded from files. If the function does
%	not generate the correct arrays then the result for each order is
%	displayed.

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin.

test_range=primes(31);
test_range(1:2)=[];
i=1;
for p=test_range
    if ~ismember(2,primelem(p))
        test_range(i)=NaN;
    end
    i=i+1;
end
test_range(isnan(test_range))=[];
check=false(size(test_range));
i=1;
for p=test_range
    generated=minimal(lempel3(p));
    loaded=load(['c' sprintf('%.2d',p-3) '_L3uni.out']);
    check(i)=isequal(generated,loaded);
    i=i+1;
end
out=all(check);
if out==false
    disp(test_range)
    disp(check)
end