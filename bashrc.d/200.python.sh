#!/usr/bin/env bash

if ! hash python3 2>/dev/null; then
  return
fi

pip3_install()
{
  python3 -m pip install --user --upgrade -r $DOTFILES/requirements.txt
}

alias venv_init='python3 -m venv venv'
alias venv_activate='source venv/bin/activate && pip3 install --upgrade pip'

