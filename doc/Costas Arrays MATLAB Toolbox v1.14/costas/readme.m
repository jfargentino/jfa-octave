% README file for the Costas Array Toolbox
%
% These MATLAB functions were created for use in the generation,
% classification and manipulation of Costas arrays. The code was
% created and is maintained by Ken Taylor, Konstantinos Drakakis
% and Scott Rickard.
%
% For more information on Costas arrays and the latest version of
% the Costas Array Toolbox, consult:
%                    www.costasarrays.org
%
%
% This material is based upon works supported by the Science Foundation
% Ireland under Grant No. 05/YI2/I677.
%
% About Version 1.13
%--------------------
% Combined all cadd functions into one
% Combined all crem functions into one
% Renamed shannon function to drt
% Combined all dflip and drot functions into dsym
%
% Release date 17 July 2009
%
% About Version 1.12
%--------------------
% Minor update
% Fixed bug in dflipadiag function
% Fixed typo in correlationsurface function 
%
% Release date 23 January 2009
%
% About Version 1.11
%--------------------
% Added 4 functions to generate Beard spins
% Changed input arguments for Golomb, Lempel & Taylor functions
% Renamed Welch functions and added an extra one
% Fixed buy in cremul
% Fixed Contents file to show all functions
%
% Release date 04 November 2008
%
% About Version 1.1
%--------------------
% Major update with naming convention changes to all functions
% All flips and rotations are obtained from seperate functions
% Adding and removing corner dots have seperate functions for each corner
% Added rickard(x,n) function
% Added shannon(x,n) function
% Added caddall(A) function
% Added costas(A) function
%
% Release date 16 September 2008
%
% About Version 1.03
%--------------------
% Updated the database
% Added testing feature
% Fixed bug in gen_T4
% Fixed bug in gen_W0
% Altered op_CornerRem output for no arrays with a corner dot
% Minor change to a couple functions when output is empty
%
% Release date 18 June 2008
%
% About Version 1.02
%--------------------
% Fixed bug in cl_IsCostas resulting from previous update
% Communications toolbox is no longer required for cl_IsCostas to run
%
% Release date 29 May 2008
%
% About Version 1.01
%--------------------
% Added database of arrays 1-27
% Fixed bug in gen_G2
% Altered cl_IsCostas for increased speed
%
% Release date 22 April 2008
%
% About Version 1.00
% -------------------
% Release date 18 April 2008