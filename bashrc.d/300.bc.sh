#!/usr/bin/env bash

if ! hash bc 2>/dev/null; then
  return
fi

calc()
{
  if [[ $# -gt 0 ]]; then
    echo "scale=3; $*" | bc
  else
    while read line; do
      echo "$line = $(echo "scale=3; $line" | bc)"
    done
  fi
}
