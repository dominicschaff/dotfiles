sudo apt-get install jq
sudo apt-get install $(jq -r '.general + .linux | @tsv' applications.json)

mkdir -p ~/.config/openbox
ln -s $HOME/.dotfiles/config/pi-openbox.xml ~/.config/openbox/lxde-pi-rc.xml
