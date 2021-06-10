function h_m = crestWaveHeight (v_ms)
%
% function h_m = crestWaveHeight (v_ms)
%
%    To get the crest-to-through wave height (RMS) in meter from the wind speed
% in m/s (SCHULKIN & SHAFFER).
%
v_knot = ms2knots (v_ms);
v2     = v_knot .* v_knot;
h_feet = 0.0026 * sqrt (v2 .* v2 .* v_knot);
h_m    = feet2meters (h_feet);

%!demo
%! v_ms = 0:0.001:10;
%! h_m  = crestWaveHeight (v_ms);
%! grid on;
%! title ('Hauteur des vagues fonction vitesse du vent');
%! xlabel ('Vitesse du vent en noeuds');
%! ylabel ('Hauteur des vagues en metres efficaces');
%! plot (ms2knots (v_ms), h_m);
%!

