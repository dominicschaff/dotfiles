#!/usr/bin/env bash

export TERM="xterm-256color"
export HISTIGNORE="[ ]*:ls:ll:history:pwd:bg:fg"
export HISTCONTROL=ignoreboth:erasedups
export HISTTIMEFORMAT="%d/%m/%y %T "
export HISTSIZE=-1
export HISTFILESIZE=-1
export CLICOLOR=1
export TIMEFORMAT='r: %R, u: %U, s: %S'
export MDV_THEME='733.3399'
export BASH_LIB="$DOTFILES/bash_library.sh"

