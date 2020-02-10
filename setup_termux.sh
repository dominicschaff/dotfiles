#!/usr/bin/env bash

apt update
apt upgrade
apt install \
  aria2 \
  ack-grep \
  apt \
  bash \
  bmon \
  bash-completion \
  clang \
  command-not-found \
  coreutils curl \
  ffmpeg \
  findutils \
  imagemagick \
  htop \
  jq \
  less \
  libandroid-support \
  make \
  man \
  openssh \
  openssl \
  pkg-config \
  pwgen \
  python \
  readline \
  sed \
  tar \
  termux-api \
  termux-tools \
  vim \
  wget \
  termux-exec

touch ~/.hushlogin
mkdir -p ~/.termux
ln -s ~/dotfiles/config/termux.properties ~/.termux/
ln -s ~/dotfiles/config/colors.properties ~/.termux/
ln -s ~/dotfiles/config/font.ttf ~/.termux/
