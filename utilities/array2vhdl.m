function ret = array2vhdl (name, x)

if ((max (find (name == '.')) == length (name) - 1) & (name (end) == 'h'))
   filename = name;
   name = name (1:end - 2);
else
   %filename = [name, '.vhdl'];
   filename = [name, '.vhd'];
end

file = fopen (filename, 'w');
if (file == -1)
   ret = -1;
   return;
end

fprintf (file, '-- Automatically generated by OCTAVE \n\n');
fprintf (file, 'LIBRARY IEEE;\n\n');
fprintf (file, 'PACKAGE %s IS\n', name);
fprintf (file, '    FUNCTION length_%s RETURN INTEGER;\n', name);
fprintf (file, '    FUNCTION get_%s (n : IN INTEGER) RETURN INTEGER;\n', name);
fprintf (file, 'END %s;\n\n', name);

fprintf (file, 'PACKAGE BODY %s IS\n\n', name);

fprintf (file, '    -- get the array length\n');
fprintf (file, '    TYPE %s_array IS ARRAY (0 to %d) of INTEGER;\n\n', ...
         name, length (x) - 1);

fprintf (file, ...
         '    FUNCTION length_%s RETURN INTEGER IS\n', ...
         name);
fprintf (file, '        VARIABLE %s_elem : %s_array;\n', name, name);

fprintf (file, '        BEGIN\n');
fprintf (file, '        RETURN %s_elem''length;\n', name);
fprintf (file, '    END length_%s;\n\n', name);

fprintf (file, '    -- get one array''s element\n');
fprintf (file, ...
         '    FUNCTION get_%s (n : IN INTEGER) RETURN INTEGER IS\n', ...
         name);
fprintf (file, '        VARIABLE %s_elem : %s_array;\n', name, name);

fprintf (file, '        BEGIN\n');
for k = 1:length (x)
    fprintf (file, '            %s_elem(%d) := %+ld;\n', name, k - 1, x(k));
end
fprintf (file, '        RETURN %s_elem(n);\n', name);
fprintf (file, '    END get_%s;\n\n', name);
fprintf (file, 'END %s;\n\n', name);

fclose (file);
ret = 0;

