#!/usr/bin/env bash

export DOTFILES="$(dirname "${BASH_SOURCE[0]}")"

for FN in $DOTFILES/bashrc.d/*.sh ; do
    source "$FN"
done

