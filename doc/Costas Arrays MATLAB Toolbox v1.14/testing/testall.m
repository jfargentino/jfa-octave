function out=testall
%test all toolbox functions 

%	Tests all toobox functions to see if they are working correctly. The
%	function displays the name of each function which it is testing and the
%	result of the test, 1 = working, 0 = broken, and finally output a 1 if
%	all tested functions returned a 1.

%	Code by Ken Taylor, Konstantinos Drakakis & Scott Rickard, UCD.
%	Version 1.2
%	Copyright (c) 2008 by University College Dublin.

check=false(1,14);
check(1)=testgolomb2;
disp(['golomb2 - ' sprintf('%d',check(1))])
check(2)=testgolomb3;
disp(['golomb3 - ' sprintf('%d',check(2))])
check(3)=testgolomb4;
disp(['golomb4 - ' sprintf('%d',check(3))])
check(4)=testgolomb4b;
disp(['golomb4b - ' sprintf('%d',check(4))])
check(5)=testgolomb5b;
disp(['golomb5b - ' sprintf('%d',check(5))])
check(6)=testlempel2;
disp(['lempel2 - ' sprintf('%d',check(6))])
check(7)=testlempel3;
disp(['lempel3 - ' sprintf('%d',check(7))])
check(8)=testtaylor0;
disp(['taylor0 - ' sprintf('%d',check(8))])
check(9)=testtaylor1;
disp(['taylor1 - ' sprintf('%d',check(9))])
check(10)=testtaylor4;
disp(['taylor4 - ' sprintf('%d',check(10))])
check(11)=testwelch0;
disp(['welch0 - ' sprintf('%d',check(11))])
check(12)=testwelch1exp;
disp(['welch1 - ' sprintf('%d',check(12))])
check(13)=testwelch2exp;
disp(['welch2 - ' sprintf('%d',check(13))])
check(14)=testwelch3exp;
disp(['welch3 - ' sprintf('%d',check(14))])
out=all(check);