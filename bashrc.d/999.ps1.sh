#!/usr/bin/env bash

_timer_start() {
    timer=${timer:-$SECONDS}
}

_timer_stop() {
    timer_show=$((SECONDS - timer))
    unset timer
}

trap '_timer_start' DEBUG
PROMPT_COMMAND=_timer_stop

_git_status()
{
  branch="$(git branch 2> /dev/null | grep '*')"
  if [ $? -eq 0 ]; then
    echo " $(echo "$branch" | cut -d' ' -f2)"
  fi
}

_git_file_count()
{
  branch="$(git branch 2> /dev/null)"
  if [ $? -eq 0 ]; then
    files_affected="$(gf | wc -l | awk '{print $1}')"
    if [[ "$files_affected" -eq 0 ]]; then
      files_affected=""
    fi
    echo "$files_affected"
  fi
}

_print_time()
{
  if [[ $timer_show -lt 60 ]]; then
    echo "${timer_show}s"
  else
    printf "%02d:%02d" $((timer_show/60)) $((timer_show%60))
  fi
}

_git_file_color()
{
  branch="$(git branch 2> /dev/null)"
  if [ $? -eq 0 ]; then
    files_affected="$(gf | wc -l | awk '{print $1}')"
    if [[ "$files_affected" -eq 0 ]]; then
      echo -e "\e[36m"
    else
      echo -e "\e[31m"
    fi
  fi
}

_exit_code_colour()
{
  if [[ "$?" != 0 ]]; then
    echo -e "\e[31m"
  else
    echo -e "\e[92m"
  fi
}

# \h = host
# \t = time
# \W = working directory
# \$ = mode

if [ -z "$PS1_OVERRIDE" ]; then
  PS1_temp=''
  if [ -n "$PS1_PRE" ]; then
    PS1_temp="$PS1_PRE "
  fi
  PS1_temp=$PS1_temp'\[$(_exit_code_colour)\]$(date +%T) $(_print_time) \[\e[31m\]\[\e[35m\]\W'
  if hash git 2>/dev/null; then
    export PS1_temp=$PS1_temp'\[$(_git_file_color)\]$(_git_status)'
  fi
  export PS1=$PS1_temp' \[\e[00m\]\$ '
else
  export PS1=$PS1_OVERRIDE
fi
