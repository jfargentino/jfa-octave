function  [J, S] = ymd2j(YMD)
%YMD2J  Converts  Year-Month-Day  to  Julian Day Number  and  Day-of Week.
%       [J, S] = ymd2j(YMD)  converts an array  YMD  of integer rows,  each
%       of which has three entries  [ Year  Month  Day ]  for a date in the
%       Gregorian  calendar,  to a column of their  Julian Day Numbers  J
%       and an array  S  of strings  'WeekDay Day MonthName Year'  in which
%       three-letter abbreviations serve for  WeekDay and MonthName.  Dates
%       are checked for validity by using  J2YMD,  q.v.  If input  YMD  has
%       more than three columns the surplus is ignored.  The number of days
%       between two dates is the difference between their  Julian Day
%       Numbers.                              W. Kahan,  Sun. 17 Mar. 1996.

Y = YMD(:,1) ;  M = YMD(:,2) - 3 ;  K = (M < 0) ;
M = M + 12*K ;  Y = Y-K ;  % ...  Vernal  Month & Year .
D = floor( (306*M + 5)/10 ) ;  % ...  Day of  Vernal  Year.
L = floor(0.25*Y) - floor(Y/100) + floor(Y/400) - floor(Y/4000) ;
%                   The last term corrects for leap-years up to  18000 A.D.
J = L + D + 365*Y + YMD(:,3) + 1721119 ;  % ...  Julian Day Number,  unless
K = any(( j2ymd(J) ~= YMD(:,1:3) )') ;    % ...      date is invalid ?
if any(K),   % ...  Display invalid date(s),  if any.
     InvaliDates = YMD(K,:)
     error(' YMD2J  accepts only valid dates in the  Gregorian  calendar.')
  end
WeekDays = [ 'Sun. ';'Mon. ';'Tue. ';'Wed. ';'Thu. ';'Fri. ';'Sat. ' ] ;
MonthNames = [' Jan. ';' Feb. ';' Mar. ';' Apr. ';' May  ';' June '
              ' July ';' Aug. ';' Sep. ';' Oct. ';' Nov. ';' Dec. '] ;
K = rem( J-1721124, 7 ) + 1 ;  m = length(K) ;
S = zeros(m, 18) ;
for  n = 1:m ,
       WeekDay = WeekDays(K(n),:) ;                     % ...  5 char.
       Day = sprintf( '%2.0f', YMD(n,3) ) ;             % ...  2 char.
       MonthName = MonthNames(YMD(n,2),:) ;             % ...  6 char.
       Year = [ int2str( YMD(n,1) ), ' ' ] ;
       if (length(Year) > 5),  Year = Year(1:5) ;  end  % ...  5 char.
       S(n,:) = [ WeekDay, Day, MonthName, Year ] ;     % ... 18 char.
    end

