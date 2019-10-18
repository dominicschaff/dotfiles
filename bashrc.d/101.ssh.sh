#!/usr/bin/env bash

_ssh_from_file()
{
  grep '^Host' "$1" | grep -v '[?*]' | cut -d ' ' -f 2-
  grep '^Include' $1 | cut -d ' ' -f2 | while read line; do
    _ssh_from_file "$(echo "$line" | sed "s@~@$HOME@g")"
  done
}

_ssh()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(_ssh_from_file ~/.ssh/config)

    COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
    return 0
}
complete -F _ssh ssh
