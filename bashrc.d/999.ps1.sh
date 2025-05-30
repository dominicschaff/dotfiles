#!/usr/bin/env bash

_git_file_color()
{
  branch="$(git branch 2> /dev/null)"
  if [[ "$?" -eq 0 ]]; then
    files_affected="$(gf | wc -l | awk '{print $1}')"
    if [[ "$files_affected" -eq 0 ]]; then
      echo -e "\e[36m"
    else
      echo -e "\e[31m"
    fi
  fi
}

_git_status()
{
  branch="$(git branch 2> /dev/null | grep '*')"
  if [[ "$(echo "$branch" | wc -c)" -gt 1 ]]; then
    echo "$(echo "$branch" | cut -d' ' -f2)"
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
  PS1_temp=$PS1_temp'\[$(_exit_code_colour)\]$(date +%T) \[\e[31m\]\[\e[35m\]\w'
  if hash git 2>/dev/null; then
    export PS1_temp=$PS1_temp'\[$(_git_file_color)\]$(_git_status)'
  fi
  export PS1=$PS1_temp' \[\e[00m\]\n⟶ \[\e[36m\]$USER@$HOSTNAME\[\e[00m\] \$ '
else
  export PS1=$PS1_OVERRIDE
fi
