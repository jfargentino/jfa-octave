function h_m = altitude (p_Pa, p0_Pa)

%
% function h_m = altitude (p_Pa, p0_Pa)
%
% Given the pressure p_Pa (in Pascals), and the sea level pressure p0_Pa
% (101326 Pa per default), returns the altitude in meters.
%
% Ref US Standard Atmosphere 1976 (NASA)

if (nargin < 2)
    p0_Pa = 101326;
end

h_m = 44330.77*(1 - p_Pa/p0_Pa) .^ (0.1902632*ones(size(p_Pa)));

%!demo
%! p_Pa = (1000:101326)';
%! h_m  = altitude (p_Pa);
%! plot (p_Pa, h_m);
%! grid on;
%! xlabel('pressure (Pa)');
%! ylabel('altitude (m)');
%!
