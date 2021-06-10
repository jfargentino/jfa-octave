function varargout = circle_intersections (varargin)
%
% function [p0, p1] = circle_intersections (c0, r0, c1, r1)
%
% Returns intersections p0 and p1 of circles of centers c0 and c1, and radius
% r0 and r1.
%
% function [p, p01, p02, p12] = circle_intersections (c0, r0, c1, r1, c2, r2)
%
% Trilateration, it returns intersections p01, p02 and p12 of circles of
% centers c0, c1, c2 and radius r0, r1, r2. The intersections are choosed by
% minimizing their triangle perimeter.
% The fist output argument is then the bary-center of these corners.
%
% TODO Choosing points by minimizing circles equation residuals (linear and
%      non-linear least square), circle intersections clustering ...
% TODO Generalization for any number of circles
% TODO If 2 circles do not intersect, chose point on the third circle, on the
%      middle between the 3td circle intersection points
%

if (nargin <= 4)
    [varargout{1:nargout}] = __circle_intersections_2 (varargin{:});
    return
end

c1 = varargin{1};
r1 = varargin{2};
c2 = varargin{3};
r2 = varargin{4};
c3 = varargin{5};
r3 = varargin{6};

[x, y] = __circle_intersections_2 (c1, r1, c2, r2);
if (isempty (x))
    % TODO plot if nargout = 0, partial results ?
    __plot_circles ([c1, c2, c3], [r1, r2, r3]);
    return
end
_p12 = zeros (2, 2);
_p12(:, 1) = x;
_p12(:, 2) = y;

[x, y] = __circle_intersections_2 (c1, r1, c3, r3);
if (isempty (x))
    % TODO plot if nargout = 0, partial results ?
    __plot_circles ([c1, c2, c3], [r1, r2, r3]);
    return
end
_p13 = zeros (2, 2);
_p13(:, 1) = x;
_p13(:, 2) = y;

[x, y] = __circle_intersections_2 (c2, r2, c3, r3);
if (isempty (x))
    % TODO plot if nargout = 0, partial results ?
    __plot_circles ([c1, c2, c3], [r1, r2, r3]);
    return
end
_p23 = zeros (2, 2);
_p23(:, 1) = x;
_p23(:, 2) = y;

p = zeros (2, 4);
%p(:, 2:end) = __choose_points_0 ([_p12, _p13, _p23], ...
%                                 [c1, c2, c3], ...
%                                 [r1, r2, r3]);
p(:, 2:end) = __choose_points_1 ([_p12, _p13, _p23]);
p(:, 1) = mean (p(:, 2:4)')';

if (nargout == 0)
    __plot_circles ([c1, c2, c3], [r1, r2, r3], p);
else
    for (n = 1:nargout)
        varargout{n} = p(:, n);
    end
end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function __plot_circles (c, r, p)
    [x1, y1] = circle (c(:, 1), r(1));
    [x2, y2] = circle (c(:, 2), r(2));
    [x3, y3] = circle (c(:, 3), r(3));
    plot (x1, y1, 'b', c(1, 1), c(2, 1), '+b', ...
          x2, y2, 'g', c(1, 2), c(2, 2), '+g', ...
          x3, y3, 'r', c(1, 3), c(2, 3), '+r');
    if (nargin > 2)
        hold on;
        plot (p(1, 2), p(2, 2), 'ok', ...
              p(1, 3), p(2, 3), 'ok', ...
              p(1, 4), p(2, 4), 'ok', ...
              p(1, 1), p(2, 1), '*k');
        hold off;
    end
    grid on
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pout = __choose_points_0 (pin, c, r)
    % if it exists an area shared by all the circles as a whole, takes its
    % corners
    % otherwise takes corners of the area that overlap any circle anywhere.
    % TODO It looks like if the 1st area does not exist, the 2nd area exists for
    %      sure, and that they can not exist alltogether but need a proof
    % TODO this is not a good criterium since when all circles intersect on
    %      one point, it is not choosed for sure.
    pout = zeros (2, 3);

    if (((range (pin(:, 1), c(:, 3)) > r(3)) ...
                    && (range (pin(:, 2), c(:, 3)) > r(3))) ...
            || ((range (pin(:, 3), c(2)) > r(2)) ...
                    && (range (pin(:, 4), c(2)) > r(2))) ...
            || ((range (pin(:, 5), c(1)) > r(1)) ...
                    && (range (pin(:, 6), c(1)) > r(1))))
        % if an area shared by all three circles does not exist, choose
        % the area that does not cover any circle.
        if (range (pin(:, 1), c(:, 3)) < range (pin(:, 2), c(:, 3)))
            pout(:, 1) = pin(:, 1);
        else
            pout(:, 1) = pin(:, 2);
        end
        if (range (pin(:, 3), c(:, 2)) < range (pin(:, 4), c(:, 2)))
            pout(:, 2) = pin(:, 3);
        else
            pout(:, 2) = pin(:, 4);
        end
        if (range (pin(:, 5), c(:, 1)) < range (pin(:, 6), c(:, 1)))
            pout(:, 3) = pin(:, 5);
        else
            pout(:, 3) = pin(:, 6);
        end
    else
        % choose the area shared by the 3 circles
        % <= are important when circles cross on one point
        if (range (pin(:, 1), c(:, 3)) <= r(3))
            pout(:, 1) = pin(:, 1);
        else
            pout(:, 1) = pin(:, 2);
        end
        if (range (pin(:, 3), c(:, 2)) <= r(2))
            pout(:, 2) = pin(:, 3);
        else
            pout(:, 2) = pin(:, 4);
        end
        if (range (pin(:, 5), c(:, 1)) <= r(1))
            pout(:, 3) = pin(:, 5);
        else
            pout(:, 3) = pin(:, 6);
        end
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function pout = __choose_points_1 (pin)
    % Choose points that minimize the triangle perimeter (far better than area)
    % TODO transform it in a matrix op
    [r_in, c_in] = size (pin);
    if ((r_in ~= 2) || (mod (c_in, 2) ~= 0))
        warning ('input %d rows and %d columns', r_in, c_in);
        return;
    end
    pmin = Inf;
    for k1 = 0:1
        for k2 = 0:1
            for k3 = 0:1
                ptmp = sum ([ range(pin(:, 1+k1), pin(:, 3+k2)), ...
                              range(pin(:, 1+k1), pin(:, 5+k3)), ...
                              range(pin(:, 3+k2), pin(:, 5+k3)) ]);
                if (ptmp < pmin)
                    pmin = ptmp;
                    pout = [pin(:, 1+k1), pin(:, 3+k2), pin(:, 5+k3)];
                end
            end
        end
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [p0, p1] = __circle_intersections_2 (varargin)
    switch (nargin)
        case 4
        c1 = varargin{3};
        r1 = varargin{4};

        case 3
        r1 = varargin{3};
        c1 = [0.0; 0.0];

        otherwise
        %case 2
        r1 = 1.0;
        c1 = [0.0; 0.0];
    end
    c0 = varargin{1};
    r0 = varargin{2};

    % distance between centers
    d2 = (c1(1) - c0(1))^2 + (c1(2) - c0(2))^2;
    d  = sqrt (d2);
    
    % check that cicles intersect
    if ((d > r0 + r1) || (d < abs (r0 - r1)))
        p0 = [];
        p1 = [];
        return;
    end
    
    % tmps
    rd = sqrt (((r0 + r1)^2 - d2) * (d2 - (r0 - r1)^2));
    xx = (c1(1) + c0(1))/2 + (c1(1) - c0(1))*(r0^2 - r1^2)/(2*d2);
    xy = (c1(2) - c0(2))*rd/(2*d2);
    yy = (c1(2) + c0(2))/2 + (c1(2) - c0(2))*(r0^2 - r1^2)/(2*d2);
    yx = (c1(1) - c0(1))*rd/(2*d2);
    
    % solutions
    p0 = [xx + xy; yy - yx];
    p1 = [xx - xy; yy + yx];
    
    if (nargout == 0)
        [x0, y0] = circle (c0, r0);
        [x1, y1] = circle (c1, r1);
        plot (x0, y0, 'b', c0(1), c0(2), '+b', ...
              x1, y1, 'g', c1(1), c1(2), '+g');
        if (~isempty (p0))
            hold on;
            plot (p0(1), p0(2), 'or', p1(1), p1(2), 'or');
            hold off;
        end
        grid on
    end

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%!demo
%! n0 = 0.25;
%! no = n0 * randn (3, 1);
%!  % check that cicles intersect
%!  %  if ((d > r0 + r1) || (d < abs (r0 - r1)))
%! c1 = [0.0; 0.0];
%! r1 = 1.0;
%! c2 = randn (2, 1);
%! d21 = range (c2, c1);
%! while (d21 < 1)
%!     c2 = 2 * c2;
%!     d21 = range (c2, c1);
%! end
%! r2 = d21 - r1 + abs (randn (1, 1));
%! [p1, p2] = circle_intersections (c1, r1, c2, r2);
%! v3 = randn (2, 1);
%! c3 = p2 + v3;
%! r3 = range (v3);
%! circle_intersections (c1, r1 + no(1), c2, r2 + no(2), c3, r3 + no(3));

%!demo
%! c0 = [-1; +1];
%! r0 = 3;
%! c1 = [+3; -2];
%! r1 = 4;
%! circle_intersections (c0, r0, c1, r1);

