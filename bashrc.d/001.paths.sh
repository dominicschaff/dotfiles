#!/usr/bin/env bash

export PYTHONPATH="$PYTHONPATH:$DOTFILES/python_libraries"

if [ -d "$HOME/bin" ] && [[ "$PATH" =~ "$HOME/bin" ]]; then
  export PATH="$PATH:$HOME/bin"
fi

if [ -d "$HOME/.bin" ] && [[ "$PATH" =~ "$HOME/.bin" ]]; then
  export PATH="$PATH:$HOME/.bin"
fi

if [[ "$PATH" =~ "$DOTFILES/bin" ]]; then
  export PATH="$PATH:$DOTFILES/bin"
fi
