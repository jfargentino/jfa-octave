#!/bin/sh

_package_one() {
    #removing trailing / if any
    PKG_SRC=`echo $1 | sed 's/\/$//'`

    if [ ! -d "$PKG_SRC" ]; then
        echo "directory $PKG_SRC does not exist"
        return
    fi
    if [ ! -f "$PKG_SRC"/DESCRIPTION ]; then
        echo "no DESCRIPTION file in $PKG_SRC"
        return
    fi

    PKG="jfa-""$PKG_SRC"
    if [ -d "$PKG" ]; then
        echo "directory $PKG already exists"
        return
    fi

    echo "packaging $PKG into $PKG.tar.gz"
    mkdir "$PKG"
    cp LICENSE "$PKG"/COPYING
    cp "$PKG_SRC"/DESCRIPTION "$PKG"
    mkdir "$PKG"/inst
    find "$PKG_SRC" -name "*.m" -exec cp '{}' "$PKG"/inst \;
    if [ -d "$PKG_SRC"/bin ]; then
        cp -a "$PKG_SRC"/bin "$PKG"
    fi
    if [ -d "$PKG_SRC"/doc ]; then
        cp -a "$PKG_SRC"/doc "$PKG"
    fi
    if [ -d "$PKG_SRC"/data ]; then
        cp -a "$PKG_SRC"/data/* "$PKG"/inst
    fi
    tar -czf "$PKG"".tar.gz" "$PKG"
    rm -rf "$PKG"
}

if [ $# -eq 0 ]; then
    _package_one conversion
    _package_one eos80
    _package_one geometry
    _package_one image
    _package_one irig
#_package_one karhunen-leove
    _package_one signal
    _package_one simulation
    _package_one statistics
    _package_one utilities
    _package_one wavelet
else
    for x in $*; do
        _package_one $x
    done
fi

