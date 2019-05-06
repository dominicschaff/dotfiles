apt update
apt upgrade
apt install aria2 ack-grep apt bash bash-completion command-not-found coreutils curl ffmpeg htop imagemagick jq less libandroid-support man openssh openssl pwgen python readline sed tar termux-api termux-tools vim wget termux-exec

touch ~/.hushlogin
mkdir -p ~/.termux
cp ~/dotfiles/config/termux.properties ~/.termux/
cp ~/dotfiles/config/colors.properties ~/.termux/
cp ~/dotfiles/config/font.ttf ~/.termux/
