echo on
% This file provides information on the operations functions which are
% contained within the Costas toolbox. These functions are intended to be
% used to manipulate existing arrays.
%
% The first function to be examined here is dsym. Clearly any Costas array 
% which is rotated by a multiple of 90 degrees retains the Costas property.
% This function allows the user to obtain any of these rotations on a set
% of arrays labelled A. The function rotates the arrays clockwise.
%
% Take the array 1 2 4 3 as an example, obtain all rotations as follows:
%
A=zeros(4);
A(1,:)=[1 2 4 3];
A(2,:)=dsym(90,A(1,:));
A(3,:)=dsym(180,A(1,:));
A(4,:)=dsym(270,A(1,:));
plotcostas(A)
pause
%
% The other use of this function relates to flipping arrays.
% Any Costas array which is flipped about the horizontal, vertical, or 
% either diagonal also retains the Costas property. This function also 
% allows the user to obtain any of these flips on a set of arrays 
% labelled A.
%
% Take the array 1 3 4 2 as an example, obtain all axial flips as follows:
%
A=zeros(5,4);
A(1,:)=[1 3 4 2];
A(2,:)=dsym('hor',A(1,:));
A(3,:)=dsym('ver',A(1,:));
A(4,:)=dsym('mdiag',A(1,:));
A(5,:)=dsym('adiag',A(1,:));
clf
plotcostas(A)
pause
%
% Combining all the arguments for the previous function leads to dsyms(A).
% The function outputs the family of arrays in the dihedral symmetry class
% for the input sequences (i.e. all rotations and flips). The output arrays
% are sorted and repetitions are removed should they occur. For each unique
% input array, the there will be 8 different rotations and flips, unless 
% the array is symmetric about one of the diagonals, in which case there
% will be 4 arrays.
%
% Since the array 1 3 2 5 6 4 is not symmetric about either diagonal, there
% will be 8 unique rotations and flips:
%
arrays=dsyms([1 3 2 5 6 4]);
clf
plotcostas(arrays)
pause
%
% Two functions follow on from dsyms, the first is minimal(A). The
% function takes an input of one or more Costas arrays, and replaces each
% array with the flip or rotation which is minimal (the one that comes
% first lexicographically). Here we can see the two arrays beside their
% flip or rotation which is minimal.
%
arrays=zeros(4,5);
arrays(1,:)=[3 5 2 1 4];
arrays(2,:)=minimal(arrays(1,:));
arrays(3,:)=[5 1 3 4 2];
arrays(4,:)=minimal(arrays(3,:));
clf
plotcostas(arrays)
pause
%
% The second function to follow on from dsyms is uniquearrays(A).
% The function takes in a set of Costas arrays, and removes rotations and
% flips, so the output arrays are all unique. After sorting the input
% arrays, it begins by taking the first array, generating all rotations and
% flips, then removing these arrays. This process is repeated until all
% arrays are unique. Note that this function does not output the minimal
% version of each input array.
%
% Here we can see the 6 input arrays being reduced to 2 unique arrays:
%
arrays=[1 2 4 3;3 4 2 1;2 1 3 4;3 2 4 1;1 3 4 2;2 4 3 1];
unique_arrays=uniquearrays(arrays);
all_arrays=[arrays;unique_arrays];
clf
plotcostas(all_arrays)
pause
%
% The circshifts(A) function can be used to obtain all circular shifts
% of a set of arrays. This is useful in the case of Welch Costas arrays,
% which possess the property that all circular shifts of arrays are also
% Costas arrays.
%
% Here we can see all the circular shifts of a Welch array 1 2 4 3 :
%
arrays=welch1(5);
all_circ_shifts=circshifts(arrays(1,:));
clf
plotcostas(all_circ_shifts)
pause
%
% The next function can be used to expand and reduce Costas arrays.
%
% The cadd(A) function can be used to add a corner dot to a set of arrays.
% The simplest way to expand a Costas array is to add a dot at one of the
% corners, however the result is not always a Costas array. These functions
% output all arrays, regardless of whether or not the result is Costas. 
% The user should first specify the corner which they want to add a dot to,
% one of {'ul' (1), 'll' (2), 'lr' (3), 'ur' (4)}, as an argument to the 
% function, standing for upper left, lower left, lower right, and upper 
% right, and then specify the arrays which the corner dot are to be added
% to.
%
% Here we can see that the first two arrays result in new Costas arrays
% when the corner dots are added, but the third array is no longer Costas
% due to a repeat vector:
%
arrays=[2 1 5 3 4;3 1 2 5 4;1 4 2 3 5];
expanded_arrays=zeros(3,6);
expanded_arrays(1,:)=cadd('ul',arrays(1,:));
expanded_arrays(2,:)=cadd('ur',arrays(2,:));
expanded_arrays(3,:)=cadd('ul',arrays(3,:));
clf
plotcostas(expanded_arrays)
pause
%
% The crem(A) function works in exactly the same way, except it removes 
% corner dots instead of adding them. The function will only output arrays
% which they have successfully removed a corner dot from, so if you try to
% remove a corner dot which doesn't exist then the array will be dropped 
% from the output.
%
% Here we remove the corner dots from the previous arrays:
%
reduced_arrays=zeros(3,5);
reduced_arrays(1,:)=crem('ul',expanded_arrays(1,:));
reduced_arrays(2,:)=crem('ur',expanded_arrays(2,:));
reduced_arrays(3,:)=crem('ul',expanded_arrays(3,:));
clf
plotcostas(reduced_arrays)
pause
%
% The addrc(r,c,A) function can be used to add blank row and columns to an
% array, where 'r' is the row, 'c' is the column, and 'A' are the arrays.
% If only a row is to be added then set c = 0, and vice-versa. Blank
% columns are represented by a 'NaN'.
%
% Here we add a blank column to the start of the first array, and add a
% blank row and column to the center of the second array:
%
arrays=[1 3 2 6 4 5;1 5 4 6 2 3];
disp(arrays)
new_arrays=zeros(2,7);
new_arrays(1,:)=addrc(0,1,arrays(1,:));
new_arrays(2,:)=addrc(4,4,arrays(2,:));
disp(new_arrays)
clf
plotcostas(new_arrays)

pause
%
% The remrc(r,c,A) function works in the same way, except it removes rows
% and columns instead of adding them.
%
% Here we can see that removing a dot from a Costas array yields
% a new array:
%
array=[3 1 2 5 4];
disp(array)
altered=remrc(5,4,array);
disp(altered)
clf
subplot(2,2,1), plotcostas(array)
subplot(2,2,2), plotcostas(altered)
pause
%
% The adddot(r,c,A) function can be used to add dots to an array which
% contains gaps. A dot can only be added using this function if the column
% in question is empty (a NaN). The row and column are specified as above.
% If an array is not empty in the specified column then it is ignored,
% unless it already contains the desired value.
%
% Here we add a dot a an array which contains a blank column in the middle:
%
gap_array=[4 5 NaN 1 3];
filled_array=adddot(2,3,gap_array);
clf
plotcostas([gap_array;filled_array])
pause
%
% The remdot(r,c,A) function works in the same way, except it removes
% dots instead of adding them. The size of the grid is not altered by this
% operation, the dot is instead replaced by a NaN.
%
% Here we replace the center dot of an array with a NaN:
%
array=[4 2 3 5 1];
gap_array=remdot(3,3,array);
clf
plotcostas([array;gap_array])
%
% For more information on each of the operations functions, see the start
% of each function file or the user manual.
pause
echo off