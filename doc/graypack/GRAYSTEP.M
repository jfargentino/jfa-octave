function  H = graystep(d, B)
%  H = graystep(d, B)  takes bit-row  B  (every element is 0 or 1)
%   through one step forward,  if  d > 0 ,  or otherwise backward,
%   through the  Gray Cyclic Binary Codes.  Only one element of  H
%   differs from the corresponding element of  BÊ;  and repeated 
%   invocations  B = graystep(d, B)  step through all  2^length(B)
%   different  Gray  codes represented as bit-rows.  Each step 
%   takes time proportional to  length(B)  but far less than,  say,
%       H = int2btr( graynext(d, btr2int(B), length(B)) ) .
%  Actually  H == graystep(d, (B(:)' ~= 0)) ,  as if array  B  had
%   been converted to a bit-row whose every nonzero element is  1 .
%  See also  grays,  btr2gray,  gray2btr,  graynext,  grayndcs.

%  Graystep  was adapted from  J. Boothroyd's Algorithm #246  on
%  p. 701 of Comm. ACM vol. 7 (1964)  by  W. Kahan,  14 Feb. 2009  

H = (B(:)' ~= 0) ;  n = length(H) ;  d = (d > 0) ;
B = cumsum(H) ;  d = abs( (floor(B(n)*0.5)*2 - B(n)) + d )  ;
j = n+1 - sum(B ~= 0) ;  %  H(j) is first nonzero element if any.
if  d ,  H(1) = ~H(1) ;
  else
    if  (j < n) ,  H(j+1) = ~H(j+1) ;  else  H(n) = ~H(n) ;  end  
  end 
