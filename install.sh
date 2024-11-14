#!/bin/sh

set -eu

cd $(dirname $0)

git submodule update --init

if [ ! -e "deps/gnuplot-palettes/accent.pal" ]
then
    echo "missing directory 'deps/gnuplot-palettes'. Seems  git submodule didn't work"
    echo "trying direct clone of latest..."
    git clone https://github.com/naqvis/gnuplot-palettes deps/gnuplot-palettes
fi

if [ ! -e "deps/gnuplot-palettes/accent.pal" ]
then
    echo "git clone didn't work either"
    exit 2
fi

crystal run scripts/gen_palettes.cr
