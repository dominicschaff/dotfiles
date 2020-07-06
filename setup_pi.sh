sudo apt-get install \
  libjpeg-dev \
  zlib1g-dev \
  libfreetype6-dev \
  liblcms1-dev \
  libopenjp2-7 \
  libtiff5 \
  jq \
  htop \
  bmon \
  git \
  bash \
  docker \
  docker-compose \
  tmux \
  wget \
  curl \
  tree \
  ack \
  adb \
  vim \
  python3 \
  ffmpeg \
  imagemagick \
  openssl \
  pandoc \
  default-jdk

mkdir -p ~/.config/openbox
ln -s $HOME/.dotfiles/config/pi-openbox.xml ~/.config/lxde-pi-rc.xml
