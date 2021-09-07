#!/usr/bin/env bash

export PYTHONPATH="$PYTHONPATH:$DOTFILES/python_libraries"

if [ -d "$HOME/bin" ]; then
  export PATH="$PATH:$HOME/bin"
fi

if [ -d "$HOME/.bin" ]; then
  export PATH="$PATH:$HOME/.bin"
fi

if [ -d "$HOME/Library/Android/sdk/platform-tools" ]; then
  export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools"
fi

if [ -d "$HOME/Library/Android/sdk/tools" ]; then
  export PATH="$PATH:$HOME/Library/Android/sdk/tools"
fi

export PATH="$PATH:$DOTFILES/bin"
