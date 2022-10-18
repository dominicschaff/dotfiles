#!/usr/bin/env bash

export PYTHONPATH="$PYTHONPATH:$DOTFILES/python_libraries"

if [ -d "$HOME/bin" ]; then
  export PATH="$PATH:$HOME/bin"
fi

if [ -d "$HOME/.bin" ]; then
  export PATH="$PATH:$HOME/.bin"
fi

export PATH="$PATH:$DOTFILES/bin"
