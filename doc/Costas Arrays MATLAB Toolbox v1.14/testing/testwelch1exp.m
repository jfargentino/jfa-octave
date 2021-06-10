function out = testwelch1exp
%testwelch1exp determines if welch1exp.m is working correctly

%	Tests the welch1exp generation function by comparing the arrays which it
%	generates to arrays which are loaded from files. If the function does
%	not generate the correct arrays then the result for each order is
%	displayed.

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.2
%	Copyright (c) 2008 by University College Dublin.

test_range=primes(31);
check=false(size(test_range));
i=1;
for p=test_range
    generated=welch1exp(p);
    loaded=load(['c' sprintf('%.2d',p-1) '_W1uni.out']);
    check(i)=isequal(generated,loaded);
    i=i+1;
end
out=all(check);
if out==false
    disp(test_range)
    disp(check)
end