function [s_pss78, Rt, rt, Rp] = salinity_eos80 (c_Sm1, t_ipts68, p_bar)
%
% function [s_pss78, Rt, rt, Rp] = salinity_eos80 (c_Sm1, t_ipts68, p_bar)
%
% Returns the practical salinity in P.S.U. 1978
% Ref. UNESCO Technical Papers in Marine Science nb 36 (1980)
%
% Inputs:
%    - c_Sm1 conductivity in S/m, from X to X (2 < PSU < 42)
%    - t_ipts68 temperature in Celsius degrees in IPTS68, from -2 to 40 degrees
%    - p_bar relative pressure, from 0 to 1000 bars (1 bar = 1e5 Pa)
%
% If ITS90 temperature is used, we have t(IPTS68) = 1.00024 x t(ITS90)
%
% Salinity from chlorinity, chlorinity Cl is defined as "the mass of silver
% required to precipitate completely the halogens in 0.3285234 kg of the
% seawater sample".
% S = 1.80655 Cl (after 1966)
%   = 0.03 + 1.805 Cl (before 1966)
%

if (nargin < 3)
  p_bar = 0.0;
end
if (nargin < 2)
  t_ipts68 = 15.0;
end
% Conductivity of the standard seawater of practical salinity 35 at a
% temperature of 15 celsius degrees and standard atmospheric pressure.
% in S/m
c_35_15_0 = 4.29140;
if (nargin < 1)
 c_Sm1 = c_35_15_0;
end
c_ratio = c_Sm1 / c_35_15_0;

[r0, c0] = size(c_Sm1);
[r1, c1] = size(t_ipts68);
[r2, c2] = size(p_bar);

if ((r0~=r1) || (r0~=r2) || (r1~=r2) || (c0~=c1) || (c0~=c2) || (c1~=c2))
    t_ipts68 = t_ipts68(:)';
    col = length (t_ipts68);
    c_ratio = c_ratio(:);
    row = length (c_ratio);
    t_ipts68 = repmat (t_ipts68, row, 1);
    c_ratio  = repmat (c_ratio,  1  , col);
end

% TODO Sometimes the ratio is done by using conductivity of the standard
% potassium chloride solution at a temperature of 15 celsius degrees and
% standard atmospheric pressure. The standard KCl solution contains a mass of
% 32.4356 gram of KCl in a mass of 1.0kg of solution

% Rp is the ratio of the in-situ conductivity to the conductivity of the same
% sample at the same temperature but at p = 0
e1 = +2.070e-4;
e2 = -6.370e-8;
e3 = +3.989e-12;
d1 = +3.426e-2;
d2 = +4.464e-4;
d3 = +4.215e-1;
d4 = -3.107e-3;
Rp = 1.0 ...
      + p_bar .* (e1 + e2*p_bar + e3*(p_bar.*p_bar)) ...
              ./ (1.0 + d1*t_ipts68 ...
                      + d2*(t_ipts68.*t_ipts68) + (d3 + d4*t_ipts68).*c_ratio);

% rt is the ratio of the conductivity of reference seawater (having a practical
% salinity of 35) at given temperature t to its conductivity at 15 celsius
% degrees
c0 = +0.6766097;
c1 = +2.00564e-2;
c2 = +1.104259e-4;
c3 = -6.9698e-7;
c4 = +1.0031e-9;
rt = c0 ...
      + c1*t_ipts68 ...
      + c2*(t_ipts68.*t_ipts68) ...
      + c3*(t_ipts68.*t_ipts68.*t_ipts68) ...
      + c4*(t_ipts68.*t_ipts68.*t_ipts68.*t_ipts68);

% Rt is the ratio of the conductivity of seawater at temperature t to the
% conductivity of seawater of practical salinity 35 at the same temperature,
% both at a pressure of 1 standard atmosphere (p = 0)
Rt = c_ratio ./ (Rp .* rt);
sRt = sqrt (Rt);

% ds is the correction by using temperature t instead of 15 celsius degrees
% we have sum(b) == 0.0
b0 = +0.0005;
b1 = -0.0056;
b2 = -0.0066;
b3 = -0.0375;
b4 = +0.0636;
b5 = -0.0144;
k  = +0.0162;
ds = b0 + b1*sRt ...
        + b2*(sRt.*sRt) ...
        + b3*(sRt.*sRt.*sRt) ...
        + b4*(sRt.*sRt.*sRt.*sRt) ...
        + b5*(sRt.*sRt.*sRt.*sRt.*sRt);
ds = ds .* (t_ipts68 - 15.0)./(1.0 + k*t_ipts68);

% s_pss78 is the practical salinity
% we have sum(a) == 35.0
a0 =  +0.0080;
a1 =  -0.1692;
a2 = +25.3851;
a3 = +14.0941;
a4 =  -7.0261;
a5 =  +2.7081;
s_pss78 = a0 + a1*sRt ...
             + a2*(sRt.*sRt) ...
             + a3*(sRt.*sRt.*sRt) ...
             + a4*(sRt.*sRt.*sRt.*sRt) ...
             + a5*(sRt.*sRt.*sRt.*sRt.*sRt) ...
             + ds;

%!demo
%! %Check results against "UNESCO Technical Papers in Marine Science 36, The
%! %Practical Salinity Scale 1978 and the Internation Equation of State of
%! %Seawater 1980", page 17
%!
%! c_35_15_0 = 4.2914;
%!
%! c_Sm1 = 1*c_35_15_0, t_ipts68 = 15, p_bar = 0,
%! s_ref = 35, Rt_ref = 1.0, rt_ref = 1.0, Rp_ref = 1.0,
%! [s_pss78, Rt, rt, Rp] = salinity_eos80 (c_Sm1, t_ipts68, p_bar)
%! [s_pss78, Rt, rt, Rp] - [s_ref, Rt_ref, rt_ref, Rp_ref]
%!
%! c_Sm1 = 1.2*c_35_15_0, t_ipts68 = 20, p_bar = 200,
%! s_ref = 37.245628, 
%! Rt_ref = 1.0568875, rt_ref = 1.1164927, Rp_ref = 1.0169429,
%! [s_pss78, Rt, rt, Rp] = salinity_eos80 (c_Sm1, t_ipts68, p_bar)
%! [s_pss78, Rt, rt, Rp] - [s_ref, Rt_ref, rt_ref, Rp_ref]
%!
%! c_Sm1 = 0.65*c_35_15_0, t_ipts68 = 5, p_bar = 150,
%! s_ref = 27.995347,
%! Rt_ref = 0.81705885, rt_ref = 0.77956585, Rp_ref = 1.0204864,
%! [s_pss78, Rt, rt, Rp] = salinity_eos80 (c_Sm1, t_ipts68, p_bar)
%! [s_pss78, Rt, rt, Rp] - [s_ref, Rt_ref, rt_ref, Rp_ref]
%!

%!demo
%! p_bar = 0.0;
%! c_Sm1 = 0:1e-3:4;
%! t_ipts68 = -2:40;
%! s = salinity_eos80 (c_Sm1, t_ipts68, p_bar);
%! imagesc (t_ipts68, c_Sm1, s);
%! colorbar;
%! grid on;
%! xlabel ('temperature in Celsius degrees (IPTS68)');
%! ylabel ('conductivity in S/m');
%! title (sprintf('seawater salinity in P.S.U. for %.3f bar', p_bar));


