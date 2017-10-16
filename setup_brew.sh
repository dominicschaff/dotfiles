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

echo "Installing some nice tools..."
newPath=""

read -p "Install GNU apps? [Y,n]" -i Y input

if [[ $input != "N" || $input != "n" ]]; then
  brew install coreutils wget grep gnu-sed less make tree openssl --with-default-names
  newPath="$(brew --prefix coreutils)/libexec/gnubin:$newPath"
fi

read -p "Upgrade BASH? [Y,n]" -i Y input

if [[ $input != "N" || $input != "n" ]]; then
  brew install bash --with-default-names
fi

read -p "Install media converting apps? [Y,n]" -i Y input

if [[ $input != "N" || $input != "n" ]]; then
  brew install handbrake apktool ffmpeg imagemagick exiftool
fi

read -p "Install pebble? [Y,n]" -i Y input

if [[ $input != "N" || $input != "n" ]]; then
  brew install node pebble/pebble-sdk/pebble-sdk
fi

read -p "Install some fun tools? [Y,n]" -i Y input

if [[ $input != "N" || $input != "n" ]]; then
  brew install mdp fortune cowsay cmatrix
fi

brew install jq git pwgen jq pidcat ack bmon htop python3

line

echo "Setting up HomeBrew to play nice..."
echo "export PATH=\"$newPath/usr/local/bin:\$PATH\"" >> $HOME/bashrc_private

line

echo "Doing a full pull of HomeBrew"
git -C "$(brew --repo homebrew/core)" fetch --unshallow
