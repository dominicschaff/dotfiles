#!/usr/bin/env bash

if ! hash python 2>/dev/null; then
  return
fi

pip3_install()
{
  pip3 install --user --upgrade -r ~/dotfiles/requirements.txt
}

