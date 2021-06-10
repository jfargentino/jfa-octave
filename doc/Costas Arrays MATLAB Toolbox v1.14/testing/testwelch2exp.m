function out = testwelch2exp
%testwelch2exp determines if welch2exp.m is working correctly

%	Tests the welch2exp generation function by comparing the arrays which it
%	generates to arrays which are loaded from files. If the function does
%	not generate the correct arrays then the result for each order is
%	displayed.

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.1
%	Copyright (c) 2008 by University College Dublin.

test_range=primes(31);
test_range(1)=[];
check=false(size(test_range));
i=1;
for p=test_range
    generated=dsyms(welch2exp(p));
    loaded=load(['c' sprintf('%.2d',p-2) '_W2all.out']);
    check(i)=isequal(generated,loaded);
    i=i+1;
end
out=all(check);
if out==false
    disp(test_range)
    dist(check)
end