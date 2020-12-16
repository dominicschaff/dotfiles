#!/usr/bin/env bash

if [ "$(uname -o)" != "GNU/Linux" ]; then # You are using OS X
  return
fi

alias bmon='bmon -p wlan0'

update()
{
  sudo dnf update
  sudo dnf autoremove
}

core_count()
{
  sysctl -n hw.ncpu
}

core_count()
{
  cat /proc/cpuinfo | awk '/^processor/{print $3}' | wc -l
}
