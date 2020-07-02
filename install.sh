ln -s $HOME/.dotfiles/vim $HOME/.vim
ln -s $HOME/.dotfiles/vimrc $HOME/.vimrc

echo "source ~/.dotfiles/bashrc" >> ~/.bashrc

mkdir -p ~/.config/openbox

ln -s $HOME/.dotfiles/config/pi-openbox.xml $HOME/.config/openbox/lxde-pi-rc.xml
