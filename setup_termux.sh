#!/usr/bin/env bash

apt update
apt upgrade
apt install \
  ack-grep \
  apt \
  aria2 \
  bash \
  bash-completion \
  bmon \
  clang \
  command-not-found \
  coreutils \
  curl \
  ffmpeg \
  findutils \
  gawk \
  git \
  graphviz \
  htop \
  imagemagick \
  jq \
  less \
  make \
  man \
  nmap \
  openssh \
  openssl \
  pwgen \
  python \
  readline \
  sed \
  silversearcher-ag \
  tar \
  termux-api \
  termux-exec \
  termux-tools \
  vim \
  wget

touch ~/.hushlogin
mkdir -p ~/.termux
ln -s ~/dotfiles/config/termux.properties ~/.termux/
ln -s ~/dotfiles/config/colors.properties ~/.termux/
ln -s ~/dotfiles/config/font.ttf ~/.termux/
