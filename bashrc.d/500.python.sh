#!/usr/bin/env bash

if ! hash pip3 2>/dev/null; then
  return
fi

pip3_install()
{
  python3 -m pip install --user --upgrade -r $DOTFILES/requirements.txt
}

