function [n_trig, n_untrig] = trigger_index (x, trig_thresh, untrig_thresh)
%
% function [n_trig, n_untrig] = trigger_index (x, trig_thresh, untrig_thresh)
%
if nargin < 3
   untrig_thresh = trig_thresh;
end

n_trig = [];
n_untrig = [];
n1 = 1;
n0 = min (find (x > trig_thresh));
while ((length (n0) ~= 0) && (length (n1) ~= 0))
   n_trig = [n_trig, n0];
   n1 = min (find (x(n0:end) <= untrig_thresh)) + n0 - 1;
   if (length (n1) == 0)
      n_untrig = [n_untrig, length (x)];
      n0 = [];
   else
      n_untrig = [n_untrig, n1];
      n0 = min (find (x(n1:end) > trig_thresh)) + n1 - 1;
   end
end

%!demo
%! x = [0:10, 11, 10:-1:0, 1:16, 15:-1:-5];
%! trig = 5;
%! untrig = 5;
%! [n_trig, n_untrig] = trigger_index (x, trig, untrig);
%! n = 1:length (x);
%! plot (n, x, n, repmat (trig, 1, n(end)), n, repmat (untrig, 1, n(end)));
%! grid on
%! disp ('x value when trigger occured:');
%! x (n_trig)
%! disp ('x value when untrigger occured:');
%! x (n_untrig)

