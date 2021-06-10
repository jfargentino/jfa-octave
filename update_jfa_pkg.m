function update_jfa_pkg (what)

if (nargin == 0)
    what = 3
end

% uninstall all
pkg -nodeps -verbose uninstall 'jfa-simulation'
pkg -nodeps -verbose uninstall 'jfa-eos80'
pkg -nodeps -verbose uninstall 'jfa-geometry'
pkg -nodeps -verbose uninstall 'jfa-image'
pkg -nodeps -verbose uninstall 'jfa-irig'
pkg -nodeps -verbose uninstall 'jfa-signal'
pkg -nodeps -verbose uninstall 'jfa-statistics'
pkg -nodeps -verbose uninstall 'jfa-conversion'
pkg -nodeps -verbose uninstall 'jfa-utilities'
pkg -nodeps -verbose uninstall 'jfa-wavelet'

if (what > 0)
    % install all
    pkg install 'jfa-conversion.tar.gz'
    pkg install 'jfa-eos80.tar.gz'
    pkg install 'jfa-geometry.tar.gz'
    pkg install 'jfa-image.tar.gz'
    pkg install 'jfa-irig.tar.gz'
    pkg install 'jfa-signal.tar.gz'
    pkg install 'jfa-simulation.tar.gz'
    pkg install 'jfa-statistics.tar.gz'
    pkg install 'jfa-utilities.tar.gz'
    pkg install 'jfa-wavelet.tar.gz'
end

if (what > 1)
    % load all
    pkg load 'jfa-conversion'
    pkg load 'jfa-eos80'
    pkg load 'jfa-geometry'
    pkg load 'jfa-image'
    pkg load 'jfa-irig'
    pkg load 'jfa-signal'
    pkg load 'jfa-simulation'
    pkg load 'jfa-statistics'
    pkg load 'jfa-utilities'
    pkg load 'jfa-wavelet'
end

