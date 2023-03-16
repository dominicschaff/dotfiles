#!/usr/bin/env bash

if ! hash flatpak 2>/dev/null; then
  return
fi

fp_clean='flatpak uninstall --unused'
fp_list='flatpak --columns=app,name,size,installation,version,branch list'
