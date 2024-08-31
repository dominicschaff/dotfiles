#!/usr/bin/env bash

if [ "$(uname -o)" != "GNU/Linux" ]; then # You are using OS X
  return
fi

update()
{
  if hash dnf 2>/dev/null; then
    sudo dnf update --refresh
  fi
  if hash apt 2>/dev/null; then
    sudo apt update
    sudo apt upgrade
    sudo apt dist-upgrade
    sudo apt autoclean
    sudo apt autoremove
    sudo apt autopurge
  fi
  if hash flatpak 2>/dev/null; then
    flatpak update --user
    sudo flatpak update
  fi
}

core_count()
{
  cat /proc/cpuinfo | awk '/^processor/{print $3}' | wc -l
}
