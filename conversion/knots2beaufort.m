function force = knots2beaufort (Vkt)

%BEAUFORT = [0, 1; ...   %0
%            1, 3; ...   %1
%            4, 6; ...   %2
%            7, 10; ...  %3
%            11, 15; ... %4
%            16, 20; ... %5
%            21, 26; ... %6
%            27, 33; ... %7
%            34, 40; ... %8
%            41, 47; ... %9
%            48, 55; ... %10
%            56, 63; ... %11
%            64, +Inf];  %12

Vkmh = 3600 * knots2ms (Vkt) / 1000;
force = min (round (((Vkmh .* Vkmh) / 9) .^ (1/3)), repmat (12, size (Vkt)));

%!demo
%! Vkt = 0:0.1:80;
%! plot (Vkt, knots2beaufort (Vkt));
%! xlabel ('wind speed in knots');
%! ylabel ('Beaufort wind force scale');
%! grid on
