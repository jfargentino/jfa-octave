function k = win_norm_factor (w)
if (length (w) > 1)
   k = sum (w .* w / length (w), 1);
else
   % uniform window
   k = 1;
end
