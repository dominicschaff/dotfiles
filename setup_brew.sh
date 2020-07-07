#!/usr/bin/env bash

if hash brew 2>/dev/null; then
  echo "Skipping HomeBrew install, as it is done already"
else
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew install jq
brew install $(jq -r '.general + .osx | @tsv' applications.json)

echo "export PATH=\"$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:\$PATH\"" >> $HOME/.bashrc
git -C "$(brew --repo homebrew/core)" fetch --unshallow

