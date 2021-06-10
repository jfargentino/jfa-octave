function  YMD = j2ymd(J)
%J2YMD  Converts  Julian Day Number  to  Gregorian  Year, Month, Day.
%       YMD = j2ymd(J)  converts a column  J  of positive integers to an
%       array of rows of three integers standing for  [ Year Month Day ]
%       in the  Gregorian  calendar promulgated by  Gregory XIII  starting
%       with  J = 2299161  on  Fri. 15 Oct. 1582 .  To keep  Pope Gregory's
%       calendar synchronized with the seasons for the next  16000  years
%       or so,  a small correction has been introduced;  millennial years
%       divisible by  4000  are not considered leap-years.  The number of
%       days between two dates is the difference between their  Julian Day
%       Numbers.  See also  YMD2J .           W. Kahan,  Sun. 17 Mar. 1996.

K = (J < 2299161) ;
if any(K),
   disp('NOTICE:  The  Gregorian  calendar started on  Fri. 15 Oct. 1582.')
   J(K) = J(K) - 10*K(K) ; % ... Try  Julian  calendar for  1501 - 1582 .
elseif any(J < 2361222),
   disp('WARNING:  England and its possessions remained  10  or  11  days')
   disp('          behind this  Gregorian  calendar until  14 Sep. 1752.')
elseif any(J > 3182088),
   disp('WARNING:  No consensus has been reached yet about dates beyond')
   disp('          Mon. 28 Feb. 4000 ,  and dates after  18000  A.D.  are')
   disp('          extremely speculative at best.')
   end
J = J - 1721119 ;
y = floor( (4000*J + 1608)/1460969 ) ;  % ...  Vernal year,  usually.
j = floor(0.25*y) - floor(y/100) + floor(y/400) - floor(y/4000) + 365*y ;
d = J - j ;  K = (d <= 0) ;  % ...  d = day of  Vernal  year  y  if  > 0 .
if any(K) ,  % ...  Adjust  y  and  d :
  u = y(K) ;  u = u-1 ;  y(K) = u ;
  j = floor(0.25*u) - floor(u/100) + floor(u/400) - floor(u/4000) + 365*u ;
  d(K) = J(K) - j ;
  end
m = floor( (10*d - 5)/306 ) ;
d = d - floor( (306*m + 5)/10 ) ;  % ...  Day  d  of  Vernal  month  m .
m = m+3 ;  K = (m > 12) ;  % ...  Convert to  Calendar  day and Month.
m(K) = m(K) - 12*K(K) ;  y(K) = y(K) + K(K) ;
YMD = [ y, m, d ] ;

