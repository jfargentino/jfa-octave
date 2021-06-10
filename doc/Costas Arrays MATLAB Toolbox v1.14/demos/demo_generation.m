echo on
% This file provides information on the generation functions which are
% contained within the Costas toolbox. These functions can be used to
% obtain Costas arrays from prime numbers (p), and powers of prime numbers
% (q). The various generation methods yield Costas arrays ranging from size
% q - 5 to q. All generation methods are based on finite field theory.
%
% The first function to be examined here is primelem(p). The function
% returns all the primitive elements in GF(p) or GF(q). These can
% then be used to construct Costas arrays using the methods below. If a
% prime number is entered, the function returns a vector of elements. If a
% prime power is entered, the function returns rows of irreducible
% polynomials, with 1's and 0's representing reducing powers of x:
%
primelem(11)
primelem(27)
pause
%
% The first generation technique is the Welch construction. W1 Welch arrays
% are constructed by taking a primitive element from GF(p), and raising it
% to successive powers, modulo p. Thus each primitive element in GF(p)
% generates a different Costas array of size p-1.
%
% From the W1 arrays it is possible to obtain more arrays of different
% sizes. Since all W1 arrays have a dot at (1,1), this dot can be removed
% to create W2 arrays. If the primitive element used for generation is 2
% then there will be a dot located at (2,2), which can be removed along
% with the dot at (1,1) to created W3 arrays. It is also possible that
% adding a corner dot to a W1 array may yield a Costas array, these are
% called W0 arrays.
%
% Due to the periodic nature of Welch Costas arrays, all circular shifts
% are also Costas arrays.
%
% Since there are 4 primitive elements in GF(11), we can generate 4 W1
% arrays of size p-1:
%
arrays=welch1exp(11);
clf
plotcostas(arrays)
%
% We can see from the plot that the upper left corner dot can be removed
% from all the W1 arrays to create 4 W2 arrays, however only the first
% array has a dot at (2,2), so this is the only array that can yield a W3
% array. It is also possible to create 3 W0 arrays of size 11.
%
% The first arguement passed to the Welch generation functions should be
% the prime number used, which dictates the size of the arrays. If you wish
% to specify the primitive elements used for generation then you can enter
% them as the second argument. Finally if any circular shift is required
% then this can be specified as the third argument. Each circular shift
% moves the first element to the end.
%
% Here we specify that we want to obtain a W2 array which is generated
% using the prime number 11, and primitive element 6. If no circular
% shifting is desired then no third arguement is entered:
%
welch2exp(11,6)
%
% For more information on each of the Welch array generation functions, see
% the start of each function file or the user manual.
%
pause
%
% The second generation technique is the Golomb construction. It generates
% Costas arrays from primes numbers (p), and powers of primes (q). G2
% Golomb arrays are constructed by placing a dot in position (i,j) on a
% grid if and only if a^i + b^j = 1, taken modulo q. Thus each pair of
% primitive elements generates a different Costas array of size q-2.
%
% From the G2 arrays it is possible to obtain more arrays of different
% sizes. If the primitive elements used to generate an array a + b = 1,
% modulo q, then there will be a dot at (1,1) which can be removed to
% create G3 arrays. If q is of the form 2^n, where n>2, then there will be
% dots at (1,1) and (2,2) which can be removed from the arrays to create G4
% arrays. If a + b = 1, and a^2 + b^-1 = 1, then there will be dots at
% (1,1) and (2,q-2) which can be simultaneously removed from G2 arrays to
% create G4b arrays. Following on from the G4b arrays, they will always
% contain a dot at (q-2,2) which can be removed to create G5b arrays.
%
% In the case of all the functions which remove dots from G2 arrays above,
% the G2 arrays can be passed straight into the functions to obtain the new
% arrays more quickly.
%
% There are 8 G2 which can be generated for q=9:
%
arrays=golomb2(9);
clf
plotcostas(arrays)
pause
%
% We can see that the first array from the can have it's (1,1) dot removed
% to create a G3 array, then the dot at (2,q-2) can be removed to create a
% G4b array, and finally then the dot at (q-2,2) can be removed to create a
% G5b array.
%
% The first agrument passed to the Golomb generation functions can be a
% prime or a power of a prime. If a prime is entered for the first
% arguement, the second argument can be entered to specify the power of
% prime required. If the prime and a power are entered, values for
% primitive element a can be specified. The function will then output all
% arrays which take these values for a. Should you require one specific
% array, you can specify both primitive elements a and b.
%
% For example, here we wish to generate a G2 Golomb array using prime
% number 5, raised to the second power, with primitive elements a = 1 0,
% and b = 2 0. The result is the following array:
%
golomb2(5^2,[1 0],[2 0])
%
pause
%
% There are 2 Taylor variations to the Golomb construction, the T1 variant
% tries to add a corner dot to G2 arrays, which can be done when p is not
% 2. Passing arguments to the function is exactly the same as with the G2
% function. Only G2 arrays which it has successfully added a corner dot to
% will be given as output:
%
arrays=taylor1(7);
clf
plotcostas(arrays)
pause
%
% The T0 Taylor variant tries to add two corner dots to G2 Golomb arrays.
% Dots are either added at the top left and bottom right corners, or at the
% top right and bottom left corners. As with T1 arrays, only G2 arrays
% which it has successfully added two corners dots to will be given as
% output:
%
arrays=taylor0(11);
clf
plotcostas(arrays)
%
% For more information on each of the Golomb array generation functions,
% and their variants, see the start of each function file or the user
% manual.
%
pause
%
% Next we have Lempel Costas arrays. These are Golomb arrays with the
% second primitive element, b, being equal to the first, a. Thus one Lempel
% Costas array will be generated from each primitive element in GF(q). Note
% that setting b = a results in generating arrays which are symmetric about
% the main diagonal.
%
% Passing arguments to the L2 function is the same as for Golomb arrays,
% except that you only need to specify primitive element a if you want a
% certain array, then b is automatically given the same value:
%
arrays=lempel2(11);
clf
plotcostas(arrays)
pause
%
% If an L2 array has a dot at (1,1), it can be removed to create an L3
% array. The function generates L2 arrays using the parameters entered,
% provided that 2 is primitive in GF(q), and then outputs arrays which
% contained a dot at (1,1) to remove:
%
array=lempel3(29);
clf
plotcostas(array)
pause
%
% The Taylor variant to Lempel arrays generates T4 arrays of size q - 4
% when a^2 + a^1 = 1, taken modulo p. When a satisfies this condition then
% there will be dots at (2,1) and (1,2) which can simulaneously be removed
% to generate a new array.
%
% An example of a T4 array can be seen here:
%
array=taylor4(19,14);
clf
plotcostas(array)
%
% For more information on each of the Lempel array generation functions,
% and the variant, see the start of each function file or the user
% manual.
pause
echo off