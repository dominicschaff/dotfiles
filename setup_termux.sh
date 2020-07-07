#!/usr/bin/env bash

apt update
apt upgrade
apt install jq
apt install $(jq -r '.general + .termux | @tsv' applications.json)

touch ~/.hushlogin
mkdir -p ~/.termux
ln -s ~/dotfiles/config/termux.properties ~/.termux/
ln -s ~/dotfiles/config/colors.properties ~/.termux/
ln -s ~/dotfiles/config/font.ttf ~/.termux/

curl -LO https://its-pointless.github.io/setup-pointless-repo.sh
bash setup-pointless-repo.sh
apt install numpy scipy
