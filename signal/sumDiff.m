function sd = sumDiff (x)
%
% function sd = sumDiff (X)
%             ___
% To perform  \   (-1)^n * Xn
%             /__
%              n
%
% If length (X) == N, this is (N/2)+1 value of fft(X)
%
x = x (:);
N = length (x);
sd = sum (x(1:2:end)) - sum (x(2:2:end));
