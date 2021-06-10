function col = get_col_by_name (head_str, col_str)

n = find (head_str == ',');
x = min (strfind (head_str, col_str));
col = min (find (n - x > 0));
