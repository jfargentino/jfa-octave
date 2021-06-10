function [a1, a2, a3, a4] = anscombe ()
%
% Anscombe's quartet is four dataset that have nearly identical statistical
% properties but that look really different when graphed.
%
% They were constructed in 1973 by Francis Anscombe to demonstrate the
% importance of graphing data and the effct of outliers on statistical
% properties.
%
% Ref: "Graph in Statistical Analysis", F. J. Anscombe in
% The American Statistician Vol. 27, No. 1
%

x1 = [10.00;  8.00; 13.00;  9.00; 11.00; ...
      14.00;  6.00;  4.00; 12.00;  7.00; 5.00];
y1 = [ 8.04;  6.95;  7.58;  8.81;  8.33; ...
       9.96;  7.24;  4.26; 10.84;  4.82; 5.68];
a1 = [ x1, y1 ];

y2 = [ 9.14;  8.14;  8.74;  8.77;  9.26; ...
       8.10;  6.13;  3.10;  9.13;  7.26; 4.74];
a2 = [ x1, y2 ];

y3 = [ 7.46;  6.77; 12.74;  7.11;  7.81; ...
       8.84;  6.08;  5.39;  8.15;  6.42; 5.73];
a3 = [ x1, y3 ];

x4 = [ 8.00;  8.00;  8.00;  8.00;  8.00; ...
       8.00;  8.00; 19.00;  8.00;  8.00; 8.00];
y4 = [ 6.58;  5.76;  7.71;  8.84;  8.47; ...
       7.04;  5.25; 12.50;  5.56;  7.91; 6.89];
a4 = [ x4, y4 ];

if (nargout == 0)

    Xmin = min([x1; x4]) * 0.9;
    Xmax = max([x1; x4]) * 1.1;
    Ymin = min([y1; y2; y3; y4]) * 0.9;
    Ymax = max([y1; y2; y3; y4]) * 1.1;

    mx1 = mean (x1)
    vx1 = var (x1)
    my1 = mean (y1)
    vy1 = var (y1)

    subplot (2, 2, 1);
    plot (x1, y1, 'or');
    xlim ([Xmin, Xmax]);
    grid on;

    subplot (2, 2, 2);
    plot (x1, y2, 'or');
    xlim ([Xmin, Xmax]);
    grid on;

    subplot (2, 2, 3);
    plot (x1, y3, 'or');
    xlim ([Xmin, Xmax]);
    grid on;

    subplot (2, 2, 4);
    plot (x4, y4, 'or');
    xlim ([Xmin, Xmax]);
    grid on;

end

