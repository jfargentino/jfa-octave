function speak = irig2peaks (s)

% replace high-level period by peak
speak = s - mean (s);
speak = speak / max (abs (speak));
speak (find (speak >= 0.5)) = 1;
speak (find (speak < 0.5)) = 0;
speak = diff (speak);
speak (find (speak < 0)) = 0;
speak = [0; speak];

% fine replace peak on alternance beginning
n_high = find (speak == 1);
n0 = n_high(1);
noffset = max (find (s(1:n0) < 0));
if (isempty (noffset))
    n0 = n_high(2);
    noffset = max (find (s(1:n0) < 0));
end
z = zeros (n0 - noffset - 1, 1);
speak = speak (n0 - noffset : end);
speak = [speak; z];

