function fred ( )

%Filter coefficients for daub4 (h<->scaling, g<->wavelet)

h = [ 1+sqrt(3) 3+sqrt(3) 3-sqrt(3) 1-sqrt(3)] / (4*sqrt(2));
g = [-h(4) +h(3) -h(2) +h(1)];

%Calculate 5 iterations of the cascade algorithm

[s,w]=cascade(5,h,g);

figure ( 1 )
plot(s); %Plot scaling function

figure ( 2 )
plot(w); %Plot wavelet function

figure ( 3 )
s = cascade2 ( 5, h );
plot ( s )

figure ( 4 )
w = cascade1 ( 5, h, g );
plot ( w )

figure ( 5 )
s = cascade3 ( 5, h, h );
so
plot ( s )

figure ( 6 )
w = cascade3 ( 5, g, h );
plot ( w )

return
end
function [s,w] = cascade(n,cs,cw)

 s = cs;
 w = cw;
 x2(1:2:length(w)*2) = w;
 x2(2:2:end)=0;
 x(1:2:length(s)*2) = s;
 x(2:2:end)=0;

 for i = 1:n

 s = conv(x,cs);
 w = conv(x2,cs);

 x2(1:2:length(w)*2) = w;
 x2(2:2:end)=0;
 x(1:2:length(s)*2) = s;
 x(2:2:end)=0;

 end

end
function w = cascade1 ( n, cs, cw )

 w = cw;
 x2(1:2:length(w)*2) = w;
 x2(2:2:end)=0;

 for i = 1:n

 w = conv(x2,cs);

 x2(1:2:length(w)*2) = w;
 x2(2:2:end)=0;

 end

end
function s = cascade2(n,cs)

 s = cs;
 x(1:2:length(s)*2) = s;
 x(2:2:end)=0;

 for i = 1:n

 s = conv(x,cs);

 x(1:2:length(s)*2) = s;
 x(2:2:end)=0;

 end

end
function s = cascade3 ( n, c1, c2 )

%*****************************************************************************80
%
%% CASCADE carries out the cascade algorithm.
%
%  Licensing:
%
%    This code is distributed under the GNU LGPL license.
%
%  Modified:
%
%    14 February 2003
%
%  Author:
%
%    John Burkardt
%
  s = c1;

  for i = 1 : n

    nx = length ( s ) * 2 - 1;

    x(1:2:nx)   = s;
    x(2:2:nx-1) = 0;

    s = conv ( x, c2 );

  end

end
