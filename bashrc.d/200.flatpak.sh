#!/usr/bin/env bash

if ! hash flatpak 2>/dev/null; then
  return
fi

alias fp_clean='flatpak uninstall --unused'
alias fp_list='flatpak --columns=app,name,size,installation,version,branch list'
