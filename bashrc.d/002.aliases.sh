#!/usr/bin/env bash

alias cd..="cd .."
alias ls="ls -GpFh --color --group-directories-first"
alias l="ls"
alias ll="ls -l"
alias la="ll -a"
alias less='less -R -S -# 10'
alias curl="curl -w \"\\n\""
alias wget='wget -c'
alias code="cd $HOME/Code"
alias reload="source ~/.bashrc"
alias termsize='echo $COLUMNS x $LINES'
alias web="python3 -m http.server"
alias st='top -o VIRT,RES,SHR,%CPU,%MEM,TIME+,CMDLINE -q'
alias m='mv -i'
alias e="editor"

alias f="declare -F | cut -d' ' -f'3-'"
alias h="type"

alias encrypt='openssl enc -aes-256-cbc -pbkdf2 -salt -in'
alias decrypt='openssl enc -d -aes-256-cbc -pbkdf2 -salt -in'

alias exts='find . -type f | while read f; do echo "${f##*.}"; done | sed "/^\s*$/d" | sort | uniq -c | sort -rn'

alias myip='curl -s -w "\n" "http://whatismyip.akamai.com"'

alias local_ip="ifconfig | grep inet | grep broadcast | rev | cut -d' ' -f7 | rev"


if hash tree 2>/dev/null; then
  alias tt="tree -hpsDAFCQ --dirsfirst"
  alias lf="tt -P"
  alias lr="tt -a"
  alias ld="tt -a -d"
fi

alias clock='tty-clock  -s -c -C 5'

alias cp="cp -i"
alias mv="mv -i"
alias df="df -h"
alias rm="rm -I"
