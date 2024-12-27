#!/usr/bin/env bash

if ! hash poetry 2>/dev/null; then
  return
fi

poetry_wipe()
{
  rm -rf ~/.cache/pypoetry
}

alias poetry_env_wipe='rm -rf $(poetry env info -p)'

