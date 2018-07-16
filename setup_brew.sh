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

newPath=""

brew install coreutils wget grep gnu-sed less make tree openssl vim bash --with-default-names
brew install handbrake apktool ffmpeg imagemagick exiftool mdp fortune cowsay cmatrix jq git pwgen jq pidcat ack bmon htop python3
brew install pandoc scala sbt shellcheck
# brew install osmosis gdal
# brew install node pebble/pebble-sdk/pebble-sdk
echo "export PATH=\"$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:\$PATH\"" >> $HOME/.bashrc
git -C "$(brew --repo homebrew/core)" fetch --unshallow


pip3 install --user --upgrade awscli paho-mqtt pg8000 pyfiglet qrcode termcolor youtube-dl sty