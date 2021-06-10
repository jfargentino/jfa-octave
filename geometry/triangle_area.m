function area = triangle_area (a, b, c)

%area = b .* sqrt (a.^2 - (b.^2 + a.^2 - c.^2)./(2*b)) / 2;
% Heron's formula
area = sqrt ((a.^2 + b.^2 + c.^2).^2 - 2*(a.^4 + b.^4 + c.^4)) / 4;



