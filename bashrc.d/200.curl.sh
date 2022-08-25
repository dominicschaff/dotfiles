#!/usr/bin/env bash

if ! hash curl 2>/dev/null; then
  return
fi

moon()
{
  curl 'http://wttr.in/Moon'
}

weather()
{
  if [[ $# -ge 1 ]]; then
    for f in "$@"; do
      curl "http://wttr.in/$f"
    done
  else
    if [ -z "$WEATHER_LOCATION" ]; then
      curl 'http://wttr.in/cape_town'
    else
      curl "http://wttr.in/$WEATHER_LOCATION"
    fi
  fi
}

cheat()
{
  for f in "$@"; do
    curl "https://cheat.sh/$f"
  done
}
