#!/usr/bin/env bash

export TERM="xterm-256color"
export HISTIGNORE="[ ]*:ls:ll:history:pwd:bg:fg"
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT="%d/%m/%y %T "
export HISTSIZE=-1
export HISTFILESIZE=-1
export CLICOLOR=1
export TIMEFORMAT='r: %R, u: %U, s: %S'
export BASH_LIB="$DOTFILES/bash_library.sh"


# Turn on parallel history
shopt -s histappend

# Turn on checkwinsize
shopt -s checkwinsize