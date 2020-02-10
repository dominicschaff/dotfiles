#!/usr/bin/env bash

if ! hash python 2>/dev/null; then
  return
fi

pip3_install()
{
  pip3 install --user --upgrade -r ~/dotfiles/requirements.txt
}

venv()
{
  if [ -f venv/bin/activate ]; then
    source venv/bin/activate
  else
    read -p "Would you like to create a virtual env?  " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
      virtualenv venv
    fi
  fi
}
