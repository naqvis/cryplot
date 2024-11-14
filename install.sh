#!/bin/sh

set -eu

cd $(dirname $0)

git submodule update --init

if [ ! -d "deps/gnuplot-palettes" ]
then
    echo "missing directory 'deps/gnuplot-palettes'. Seems  git submodule didn't work"
    exit 2
fi

crystal run scripts/gen_palettes.cr
