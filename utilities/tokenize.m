function [strings, w] = tokenize (str, separator)

if (nargin == 1)
	separator = ' ';
end

strings = {};
N       = find (str == separator);

if (length(N) == 0)
	strings = str;
	w       = 1;
	return;
else
	w          = 0;
	for n = 2 : length(N)
		if (N(n) - N(n-1) > 1)
			w = w + 1;
			strings{w} = str (N(n-1)+1:N(n)-1);
		end
	end
	if (N(end) != length (str))
		w = w + 1;
		strings{w} = str (N(end)+1:end);
	end
end
 
