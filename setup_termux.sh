apt update
apt upgrade
apt install ack-grep apt bash bash-completion bmon command-not-found coreutils cowsay curl ffmpeg fortune git gzip htop imagemagick jq less libandroid-support man ncurses netcat nmap openssh openssl openssl-tool pwgen python readline sed sqlite tar termux-api termux-tools vim wget

apt install clang python-dev libffi libffi-dev openjpeg openjpeg-dev libjpeg-turbo-dev

touch ~/.hushlogin
mkdir -p ~/.termux
cp ~/dotfiles/config/termux.properties ~/.termux/
cp ~/dotfiles/config/colors.properties ~/.termux/
cp ~/dotfiles/config/font.ttf ~/.termux/
