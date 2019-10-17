#!/usr/bin/env bash

export DOTFILES="$HOME/dotfiles"

for FN in $DOTFILES/bashrc.d/*.sh ; do
    source "$FN"
done

