function [p, t, s, lat, long, dstr, ptf, id] = argoread (filename)

f = fopen (filename, 'rt');
str = fgetl (f);
str2 = fgetl (f);
fclose (f);

pres = get_col_by_name (str, 'PRES (decibar)');
temp = get_col_by_name (str, 'TEMP (degree_Celsius)');
psal = get_col_by_name (str, 'PSAL (psu)');
lati = get_col_by_name (str, 'LATITUDE (degree_north)');
long = get_col_by_name (str, 'LONGITUDE (degree_east)');
pltf = get_col_by_name (str, 'PLATFORM');
arid = get_col_by_name (str, 'ARGOS_ID');
dn   = get_col_by_name (str, 'DATE');

n = find (str2 == ',');
dstr = str2(n(dn-1)+1:n(dn)-1);

xxx  = csvread (filename);
ptf  = xxx(2, pltf);
id   = xxx(2, arid);
lat  = xxx(2:end, lati);
long = xxx(2:end, long);
p    = xxx(2:end, pres)/10;
t    = xxx(2:end, temp);
s    = xxx(2:end, psal);

[p, idx] = sort (p);
t = t(idx);
s = s(idx);
lat  = lat(idx);
long = long(idx);

if (nargout == 0)

    tstr = sprintf (['platform: %d, argo id: %d\n', ...
                    'latitude %.4f, longitude %.4f\n', '%s'], ...
                    ptf, id, lat(1), long(1), dstr);

    d = density_eos80 ([s, t, p]);

    n50 = min (find (p >= 50));
    m0  = polyfit (p(1:n50-1), d(1:n50-1), 1);
    d0  = polyval (m0, p(1:n50-1));
    m50 = polyfit (p(n50:end), d(n50:end), 1);
    d50 = polyval(m50, p(n50:end));

    subplot (3, 1, 1);
    plot (d, -p, d0, -p(1:n50-1), d50, -p(n50:end));
    title (tstr);
    if (isreal(d(1)) && isreal(d(end)))
        xlim([d(1), d(end)]);
    end
    grid on;
    xlabel ('density kg/L');
    ylabel ('pressure bar');

    subplot (3, 1, 2);
    plot (p(1:n50-1), d0 - d(1:n50-1));
    xlim([p(1), p(n50-1)]);
    grid on;
    xlabel ('pressure bar');
    ylabel ('density error');

    subplot (3, 1, 3);
    plot (p(n50:end), d50 - d(n50:end));
    xlim([p(n50), p(end)]);
    grid on;
    xlabel ('pressure bar');
    ylabel ('density error');

    clear p;
end
