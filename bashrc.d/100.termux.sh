#!/usr/bin/env bash

if [ "$(uname -o)" != "Android" ]; then # You are most likely using termux
  return
fi

update()
{
  apt update

  if [[ $(apt list --upgradable 2>/dev/null | wc -l) -ge 2 ]];then
    apt upgrade
  fi
  apt autoremove
  apt autoclean
  apt autopurge
}

alias bat="termux-battery-status | jq '\"\(.percentage) : \(.temperature) (\(.status)|\(.plugged))\"'"
alias clean="apt autoremove"
alias open=termux-open

status()
{
  date
  uptime
  echo "Battery: $(bat)"
}

core_count()
{
  cat /proc/cpuinfo | awk '/^processor/{print $3}' | wc -l
}

alias pbcopy="termux-clipboard-set"
alias pbpaste="termux-clipboard-get"
