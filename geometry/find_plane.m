function [plane, c] = find_plane (pts)
%
% function [plane, c] = find_plane (pts)
%
% Found the plane defined by a minimum of three points. The plane is defined
% by its normal vector and a point.
%
% INPUT:
%    -pts: minimum of three points cordinates, points are column vectors.
%          If more than 3 points are given TODO
%
% OUTPUTS:
%    -plane: The cartesian coefficients of the plane, thus every [x, y, z] which
%            behave to the plane verify the following equation:
%            plane[0].x + plane[1].y + plane[2].z + plane[3] = 0
%            The first coefficients defines the normal vector coordinates, and
%            the last one is 0 less the scalar product between the normal vector
%            and the vector c (the iso-barycenter).
%    -c: iso-barycenter of given points, which is the vector suppport.
%

[pts, trans] = adjust_dim (pts);

% pts = 1 point per column, minimum 3x3
[dim, np] = size (pts);
if (np < 3)
   plane = [];
   c     = [];
   return
end

% Points isobarycenter
c = mean (pts, 2);

if (np == 3)
    % three points given, use the vector product to construct the normal vector
    % then the plane equation
    n = vector_product (pts(:,3) - pts(:,1), pts(:,2) - pts(:,1));
    n = n / range (n);
    plane = [n; dot(n, c)];
    if (trans)
       plane = plane';
       c     = c';
    end
    return
end

% les points recentres
g = pts - repmat (c, 1, np);

% la diagonale de la matrice
diag = sum (g .* g, 2);
A = zeros (3, 3);
A (1, 1) = diag (1);
A (2, 2) = diag (2);
A (3, 3) = diag (3);
% Le reste de la matrice
A (1, 2) = sum (g(1, :) .* g(2, :));
A (2, 1) = A (1, 2);
A (1, 3) = sum (g(1, :) .* g(3, :));
A (3, 1) = A (1, 3);
A (2, 3) = sum (g(2, :) .* g(3, :));
A (3, 2) = A (2, 3);
% Le vecteur propre de la plus petite valeur propre est le vecteur normal
[v, a] = eig (A);
[m, n] = min (sum (a, 1));
Vn = v (:, n);
% l'isobarycentre appartient au plan
d = - sum (Vn .* c);

plane = [Vn; d];

if (trans)
   plane = plane';
   c     = c';
end

%!demo
%! p0 = [0; 0; 0];
%! p1 = [1; 0; 0];
%! p2 = [0; 1; 0];
%! pts = [p0, p1, p2];
%! [plane, c] = find_plane (pts)
%! p3 = [1; 1; 0];
%! pts = [pts, p3];
%! [plane, c] = find_plane (pts)
%! [plane, c] = find_plane (pts')
