#!/usr/bin/env bash

if ! hash direnv 2>/dev/null; then
  return
fi

eval "$(direnv hook bash)"

