apt update
apt upgrade
apt install \
  aria2 \
  ack-grep \
  apt \
  bash \
  bash-completion \
  command-not-found \
  coreutils curl \
  ffmpeg \
  imagemagick \
  jq \
  less \
  libandroid-support \
  man \
  openssh \
  openssl \
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
