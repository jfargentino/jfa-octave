function [t68, dt] = its90_to_ipts68 (t90)
%
% function [t68, dt] = its90_to_ipts68 (t90)
% 
% Convert an ITS90 temperature into a IPTS68 one. Conversion is valid
% from -200 to 1064.18 Celsius degrees.
% Ref: from 83.8K to 903K, Rusby 1990
%      from 630°C to 1064°C, Rusby et al. 1994
%
% TODO: for 13.8K < t90 < 83.8K, third polynomial

a = [ +0.000000; ...
      -0.148759; ...
      -0.267408; ...
      +1.080760; ...
      +1.269056; ...
      -4.089591; ...
      -1.871251; ...
      +7.438081; ...
      -3.536296 ];

b = [ +7.8687209e+1; ...
      -4.7135991e-1; ...
      +1.0954715e-3; ...
      -1.2357884e-6; ...
      +6.7736583e-10; ...
      -1.4458081e-13; ];

dt = zeros (size(t90));
n0 = find (t90 >  630.147);
dt(n0) = polyval (flipud(b), t90(n0));
n1 = find (t90 <= 630.147);
dt(n1) = polyval (flipud(a), t90(n1)/630.0);
t68 = t90 - dt;

%!demo
%! t90 = (-200:1065)';
%! t68 = its90_to_ipts68 (t90);
%! subplot (2, 1, 1);
%! plot (t90, t90 - t68);
%! xlim ([t90(1), t90(end)]);
%! xlabel ('temperature Celsius degrees ITS90');
%! ylabel ('ITS90 - IPTS68');
%! grid on
%! subplot (2, 1, 2);
%! t90 = (-2:40)';
%! t68 = its90_to_ipts68 (t90);
%! plot (t90, t90*1.00024 - t68);
%! xlim ([-2, +40]);
%! xlabel ('temperature Celsius degrees ITS90');
%! ylabel ('error with t68 = 1.00024 x t90');
%! grid on;

