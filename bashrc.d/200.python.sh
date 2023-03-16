#!/usr/bin/env bash

if ! hash python3 2>/dev/null; then
  return
fi

pip3_install()
{
  python3 -m pip install --user --upgrade -r $DOTFILES/requirements.txt
}

py_clean()
{
  for f in "$@"; do
    isort --profile black -w 79 "$f"
    black --line-length 79 "$f"
  done
}
