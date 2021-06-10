function t = etime(t1,t0)
%ETIME  Elapsed time between two invocations of  CLOCK .
%       ETIME(T1, T0)  returns the time in seconds that has elapsed between
%       row vectors  T0  and  T1.  Each vector must have six elements,  the
%       first five positive integers,  in the format returned by  CLOCK ,
%       namely
%                 T  =  [ Year Month Day Hour Minute Second ]  .
%
%       This version of  ETIME  works across month and year boundaries but
%       does not check the validity of its arguments,  which are expected
%       to be obtained as in the following example that shows how to time
%       some  Operation  or  m-file  by using  ETIME :
%
%                 t0 = clock ;
%                 Operation or m-file
%                 etime(clock, t0)
%

%                                                  W. Kahan,  17 March 1996

t = (t1(3:6) - t0(3:6))*[ 86400 3600 60 1 ]' ;  % ... O.K. for same month.
if any ( t1(1:2) ~= t0(1:2) ) ,  % ...  Compute days between months:
    Y = [t1(1); t0(1)] ;  M = [t1(2); t0(2)] - 3 ;  K = (M < 0) ;
    M = M + 12*K ;  Y = Y-K ;  % ...  Vernal  Month & Year .
    D = floor( (306*M + 5)/10 ) ;  % ...  Day of  Vernal  Year.
    L = floor(0.25*Y) - floor(Y/100) + floor(Y/400) - floor(Y/4000) ;
    D = L + D + 365*Y ;  % ...  corrected for leap-years beyond  16000 A.D.
    t = ([1 -1]*D)*86400 + t ;
  end

