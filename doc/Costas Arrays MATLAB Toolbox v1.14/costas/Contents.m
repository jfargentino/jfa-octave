% Costas Array Toolbox
% Version 1.13 17-July-2009
%
% Costas classification functions
%   iscircshift  - Determines whether an array is a circular shift of
%                  another array
%   iscostas     - Tests sequence for Costas condition is satisfied
%   iscostasperm - Tests sequence for both Costas conditions satisfied
%   isdiagonal   - Determines whether or not an array is symmetric about
%                  the main diagonal
%   isrotflip    - Determines whether an array is a rotation or flip of 
%                  another array
%
%
%  Costas generation functions
%   golomb2   - Generates G2 Golomb Costas array sequences
%   golomb3   - Generates G3 Golomb Costas array sequences
%   golomb4   - Generates G4 Golomb Costas array sequences
%   golomb4b  - Generates G4b Golomb Costas array sequences
%   golomb5b  - Generates G5b Golomb Costas array sequences
%   lempel2   - Generates L2 Lempel Costas array sequences
%   lempel3   - Generates L3 Lempel Costas array sequences
%   primelem  - Generates the primitive elements for an input
%               prime p, or power of prime q
%   rickard   - Generates Rickard Costas array sequences
%   drt       - Generates DRT Costas array sequences
%   spinadd   - Generates Beard Costas array sequences
%   spinadd2  - Generates Beard Costas array sequences
%   spindrop  - Generates Beard Costas array sequences
%   spindrop2 - Generates Beard Costas array sequences
%   taylor0   - Generates the T0 variant to Golomb arrays
%   taylor1   - Generates the T1 variant to Golomb arrays
%   taylor4   - Generates the T4 variant to the Lempel arrays
%   welch0    - Generates W0 Welch Costas array sequences
%   welch1    - Generates W1 Welch Costas array sequences
%   welch1exp - Generates exponential W1 Welch Costas array sequences
%   welch2exp - Generates exponential W2 Welch Costas array sequences
%   welch3exp - Generates exponential W3 Welch Costas array sequences
%   
%
%  Operations functions
%   addrc        - Adds blank rows and columns to arrays
%   adddot       - Adds a dot to arrays
%   circshifts   - Generates all unique circular shifts of input arrays
%   cadd         - Adds a corner dot to a specified corner
%   crem         - Removes a corner dot from a specified corner
%   dsym         - Flips and rotates arrays to obtain dihedral symmetries
%   dsyms        - Generates the family of arrays in the dihedral
%                  symmetry class of input arrays
%   minimal      - Replaces input arrays with their flip or rotation
%                  which is minimal.
%   remrc        - Removes rows and columns from arrays
%   remdot       - Removes a dot from arrays
%   uniquearrays - Removes rotations and flips from a set of Costas arrays
%
%
%  Testing Functions
%   testall       - Run all available tests
%   testgolomb2   - Test golomb2 function
%   testgolomb3   - Test golomb3 function
%   testgolomb4   - Test golomb4 function
%   testgolomb4b  - Test golomb4b function
%   testgolomb5b  - Test golomb5b function
%   testlempel2   - Test lempel2 function
%   testlempel3   - Test lempel3 function
%   testtaylor0   - Test taylor0 function
%   testtaylor1   - Test taylor1 function
%   testtaylor4   - Test taylor4 function
%   testwelch0    - Test welch0 function
%   testwelch1exp - Test welch1exp function
%   testwelch2exp - Test welch2exp function
%   testwelch3exp - Test welch3exp function
%
%
%  Miscellaneous functions
%   correlationsurface - Generates the correlation surface for two input 
%                        arrays
%   costas             - outputs the Costas arrays from the input set
%   findcostas         - Generates all Costas arrays for small sizes
%   plotcostas         - Generates a plot of the entered Costas array
%   stubtocostas       - Searches for Costas arrays which begin with a  
%                        certain stub.
%   zeropad            - Pads the border of a hit array with zeros.
%
%  by Ken Taylor, Konstantinos Drakakis, Scott Rickard
%         Copyright University College Dublin