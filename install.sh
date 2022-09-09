#!/usr/bin/env sh

set -eu

PWD=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

pushd $PWD

git submodule update --init

if [ ! -d "deps/gnuplot-palettes" ]
then
    echo "missing directory 'deps/gnuplot-palettes'. Seems  git submodule didn't work"
    exit 2
fi

crystal run scripts/gen_palettes.cr

popd