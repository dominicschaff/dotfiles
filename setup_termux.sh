apt update
apt upgrade
apt install ack-grep apt bash bash-completion bmon busybox command-not-found coreutils cowsay curl dash dpkg ffmpeg fortune git gpgv gzip htop imagemagick jq less libandroid-support libgnustl liblzma libxml2-utils lynx man ncurses netcat nmap openssh openssl openssl-tool pwgen python readline sed sqlite tar termux-api termux-tools vim wget xvidcore

touch ~/.hushlogin
mkdir ~/.termux
cp ~/dotfiles/config/termux.properties ~/.termux/
cp ~/dotfiles/config/colors.properties ~/.termux/
cp ~/dotfiles/config/font.tff ~/.termux/