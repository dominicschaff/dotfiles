#!/usr/bin/env bash

if hash brew 2>/dev/null; then
  echo "Skipping HomeBrew install, as it is done already"
else
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

brew install \
  ack \
  apktool \
  aria2 \
  bash \
  bmon \
  cmatrix \
  coreutils \
  cowsay \
  exiftool \
  ffmpeg \
  fortune \
  git \
  gnu-sed \
  gource \
  grep \
  handbrake \
  htop \
  imagemagick \
  jq \
  less \
  make \
  mdp \
  openssl \
  openssl@1.1 \
  pandoc \
  pidcat \
  pwgen \
  python3 \
  scrcpy \
  shellcheck \
  the_silver_searcher \
  tmux \
  tree \
  vim \
  wget
echo "export PATH=\"$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:\$PATH\"" >> $HOME/.bashrc
git -C "$(brew --repo homebrew/core)" fetch --unshallow

