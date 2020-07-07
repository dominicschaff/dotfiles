#!/usr/bin/env bash

if ! hash pip3 2>/dev/null; then
  return
fi

pip3_install()
{
  pip3 install --user --upgrade -r $DOTFILES/requirements.txt
}

