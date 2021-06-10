echo on
% This file provides an explanation of what a Costas array is and what they
% can be used for.
%
% A Costas array is a grid containing dots in locations which are
% constrained by two rules:
%
% 1) Each row and column can contain only 1 dot, thus an N x N grid will 
%    contain N dots.
% 2) All of the vectors connecting pairs of dots must be distinct.
%
% For convenience Costas arrays are usually represented by permutations.
%
% If a Costas array is known, it can be viewed using plotcostas(A),
% where A is the Costas array represented in permutation form
pause
plotcostas([1 2 4 8 5 10 9 7 3 6])
% Here we can see a plot of the Costas array 1 2 4 8 5 10 9 7 3 6.
%
% Note that (1,1) is taken to be the top left of the array, which follows
% matrix notation.
pause
% To see more examples of Costas arrays, use findcostas(n). This function
% outputs all Costas arrays of order n. It does so by generating all
% permutations of size n and testing each one to see if it is a Costas
% array. This is a very inefficient way of searching/generating Costas
% arrays, and is only intended for use with n < 10.
all_size_4_arrays=findcostas(4);
disp(all_size_4_arrays)
clf
plotcostas(all_size_4_arrays)
% Note that many of the arrays in the previous plot are flips or rotations
% of other arrays. 
%
% For information on functions which can perform these
% operations, along with many others, please see the operations demo. 
pause
%
% For more information on Costas arrays see the user manual.
% Exhaustive searching is not the ideal method of obtaining Costas arrays
% of a desired size. Generation methods exist which are based on finite
% field theory. These yield arrays of size p-1 and q-2, where p is a prime
% number and q a power of a prime. From these generated arrays it is also 
% possible to obtain more arrays by removing and adding dots at specific
% locations, most commonly at the corners. 
%
% For more information on the generation methods which exist please see the 
% generation demo.
pause
% Costas arrays have applications in radar and sonar. A sonar system works
% by sending out a signal towards a target, and examining the signal which
% bounces back to the receiver. The time which it takes for the signal to
% return gives the distance of the object from the emitter/receiver, and
% the apparent change in frequency gives the speed at which it is
% traveling, relative to the emitter/receiver, via the Doppler effect.
%
% In a Costas array plot, the y-axis gives the frequency of each each blip,
% and the x-axis shows the time interval in which each blip was emitted.
pause
% If a shifted version of the original signal looked very similar to the
% original, then it might be difficult to locate the exact location of the
% target, due to many spurious targets being thrown up.
%
% Take as an example the staircase waveform 6 5 4 3 2 1. Shifting this
% array right and up by one box will produce 5 hits, hence this waveform
% has poor auto-ambiguity:
%
clf
subplot(2,2,1), plotcostas([6 5 4 3 2 1])
subplot(2,2,2), mesh(zeropad(correlationsurface([6 5 4 3 2 1],[6 5 4 3 2 1])))
axis tight
%
% Compare this with the Costas array 1 3 2 6 4 5. For any shift the
% maximum number of hits is 1. This is known as ideal thumbtack
% auto-ambiguity, which can be seen in the plot:
%
subplot(2,2,3), plotcostas([5 4 6 2 3 1])
subplot(2,2,4), mesh(zeropad(correlationsurface([5 4 6 2 3 1],[5 4 6 2 3 1])))
axis tight
% 
% Hence using a Costas array pattern increases the performance of the
% radar/sonar system by removing the possible occurance of spurious
% targets. 
echo off