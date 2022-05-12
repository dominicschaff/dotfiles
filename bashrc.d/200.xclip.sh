#!/usr/bin/env bash

if ! hash xclip 2>/dev/null; then
  return
fi

alias clip='xclip -sel clip'
