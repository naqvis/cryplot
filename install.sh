#!/bin/sh

set -eu

cd $(dirname $0)

if [[ -d ".git" ]]
then
    # This script is in the root of a git repository that should be cryplot itself.
    # Since the palettes are a subrepository, simply initialize or update it.
    git submodule update --init
else
    # This script is probably run as a shards postinstall script.

    palettes_dir="deps/gnuplot-palettes"
    palettes_repo_url="https://github.com/naqvis/gnuplot-palettes"

    if [[ -d "${palettes_dir}/.git" ]] && [[ "$(git -C "$palettes_dir" remote get-url origin)" != "$palettes_repo_url" ]]
    then
      rm -rf "$palettes_dir"
    fi

    if [[ ! -e "$palettes_dir" ]] || [[ -z "$(ls -A "$palettes_dir")" ]]
    then
        git clone "$palettes_repo_url" "$palettes_dir"
    else
        git -C "$palettes_dir" fetch
        git -C "$palettes_dir" -c advice.detachedHead=false checkout origin/master
    fi
fi

crystal run scripts/gen_palettes.cr
