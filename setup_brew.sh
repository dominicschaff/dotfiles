line()
{
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

echo "Installing HomeBrew..."

if hash brew 2>/dev/null; then
  echo "Skipping HomeBrew install, as it is done already"
else
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

line

brew install \
  ack \
  apktool \
  bash \
  bmon \
  cmatrix \
  coreutils \
  cowsay \
  exiftool \
  ffmpeg \
  fortune \
  git \
  gnu-sed \
  gource \
  grep \
  handbrake \
  htop \
  imagemagick \
  jq \
  jq \
  less \
  make \
  mdp \
  openssl \
  openssl \
  openssl@1.1 \
  pandoc \
  pidcat \
  pwgen \
  python3 \
  scrcpy \
  shellcheck \
  tmux \
  tree \
  vim \
  wget
# brew install osmosis gdal
# brew install node pebble/pebble-sdk/pebble-sdk
echo "export PATH=\"$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:\$PATH\"" >> $HOME/.bashrc
git -C "$(brew --repo homebrew/core)" fetch --unshallow
