line()
{
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

echo "Installing HomeBrew..."

/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

line

echo "Installing some nice tools..."
brew install coreutils wget tree mdp bash jq testdisk grep gnu-sed less make git pwgen pebble/pebble-sdk/pebble-sdk handbrake apktool cmatrix exiftool ffmpeg fortune cowsay jq node pebble/pebble-sdk/pebble-sdk pidcat pidlog ack bmon imagemagick openssl --with-default-names

line

echo "Setting up HomeBrew to play nice..."
echo "export PATH=\"$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:\$PATH\"" >> $HOME/bashrc_private

line

echo "Doing a full pull of HomeBrew"
git -C "$(brew --repo homebrew/core)" fetch --unshallow
