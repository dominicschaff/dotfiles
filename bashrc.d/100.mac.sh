#!/usr/bin/env bash

if [ "$(uname)" != "Darwin" ]; then # You are using OS X
  return
fi


alias top="top -F -R -o cpu"

notify()
{
  if [ $# -eq 1  ]; then
    osascript -e "display notification \"$1\" with title \"Notification\""
  elif [ $# -eq 2  ]; then
    osascript -e "display notification \"$2\" with title \"$1\""
  elif [ $# -eq 3  ]; then
    osascript -e "display notification \"$3\" with title \"$1\"  subtitle \"$2\""
  else
    echo "Can only be run with 1/2/3 arguments"
  fi
}

play()
{
  for i in "$@"; do
    echo "Playing: $i"
    afplay "$i"
  done
}

play_random()
{
  find . -iname "*.mp3" | sort -R | while read a; do echo "$a"; afplay "$a"; done
}

convertUs()
{
  for i in *; do
    avconvert -s "$i" -o "${i%.*}.m4a" -p PresetAppleM4A &
    while [ $(jobs -p | wc -l) -ge 5 ]; do sleep 1; done;
  done
  wait
}

update()
{
  brew update
  brew upgrade
}

core_count()
{
  sysctl -n hw.ncpu
}


power_usage()
{
  data="$(system_profiler SPPowerDataType)"
  amps="$(echo "$data" | grep Amperage | rev | cut -d' ' -f1 | rev)"
  volts="$(echo "$data" | grep Voltage | rev | cut -d' ' -f1 | rev)"
  usage="$(echo "scale=2; $volts/1000.0 * $amps/1000.0" | bc)"
  echo "Power usage: $usage"
}

net()
{
  bmon -p en0
}
