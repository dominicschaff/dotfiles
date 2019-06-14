#!/usr/bin/env bash

alias reload='source ~/.bashrc'
alias cd..="cd .."
alias ls="ls -GpFh --color --group-directories-first"
alias l="ls"
alias ll="ls -l"
alias la="ll -a"
alias f="declare -F | cut -d' ' -f'3-'"
alias h="type"

_timer_start() {
    timer=${timer:-$SECONDS}
}

_timer_stop() {
    timer_show=$(($SECONDS - $timer))
    unset timer
}

trap '_timer_start' DEBUG
PROMPT_COMMAND=_timer_stop

_print_time()
{
  if [[ $timer_show -lt 60 ]]; then
    echo "${timer_show}s"
  else
    printf "%02d:%02d" $((timer_show/60)) $((timer_show%60))
  fi
}

_exit_code_colour()
{
  if [ "$?" != 0 ]; then
    echo -e "\e[31m"
  else
    echo -e "\e[32m"
  fi
}

# \h = host
# \t = time
# \W = working directory
# \$ = mode

export PS1='\e[31m@office \[$(_exit_code_colour)\]$(_print_time) \[\e[31m\]\[\e[35m\]\W \[\e[00m\]\$ '
