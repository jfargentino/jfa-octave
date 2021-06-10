function mc = mycolormap (m)

MAP = {'default', ...
       'jet', ...
       'hot', ...
       'gray', ...
       'bone', ...
       'pink', ...
       'copper', ...
       'cool', ...
       'autumn', ...
       'winter', ...
       'spring', ...
       'summer', ...
       'hsv', ...
       'prism', ...
       'flag', ...
       'white'};

if (nargin == 0)
    m = 1;
end

if (isnumeric (m))
    if (m < 1) | (m > length (MAP))
        m = 1;
    end
    mapname = MAP{m};
else
   mapname = m;
end 
cm = 255 * colormap (mapname);

if (nargout == 0)
    l = (1 : length (cm)) / length (cm);
    subplot (3, 1, 1)
    stairs (l, cm (:, 1), 'r');
    title (['colormap ', mapname]);
    ylabel ('red');
    xlim ([0, l(end)])
    ylim ([0, 255]);
    grid on;
    subplot (3, 1, 2)
    stairs (l, cm (:, 2), 'g');
    ylabel ('green');
    xlim ([0, l(end)])
    ylim ([0, 255]);
    grid on;
    subplot (3, 1, 3)
    stairs (l, cm (:, 3), 'b');
    ylabel ('blue');
    xlim ([0, l(end)])
    ylim ([0, 255]);
    grid on;
    colorbar ('southoutside')
end

%!demo
%! for m = 1:16
%!    figure (m);
%!    mycolormap (m)
%! end

