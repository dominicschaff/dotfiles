#!/usr/bin/env bash

if [ "$(uname -o)" != "GNU/Linux" ]; then # You are using OS X
  return
fi

alias bmon='bmon -p wlan0'

update()
{
  sudo apt update
  sudo apt upgrade
  sudo apt full-upgrade
  sudo apt dist-upgrade
  sudo apt autoclean
}

core_count()
{
  sysctl -n hw.ncpu
}

core_count()
{
  cat /proc/cpuinfo | awk '/^processor/{print $3}' | wc -l
}
