#!/usr/bin/env bash

# Terminal Options:
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=-1
export HISTFILESIZE=-1
export CLICOLOR=1
export TIMEFORMAT='r: %R, u: %U, s: %S'

DOTFILES="$HOME/dotfiles"
GIT_ENABLE=''

################################################################################
# Create PATH
################################################################################

if [ -d "$HOME/.bin" ]; then
  export PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/Library/Android/sdk/platform-tools" ]; then
  export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools"
fi

if [ -d "$HOME/Library/Android/sdk/tools" ]; then
  export PATH="$PATH:$HOME/Library/Android/sdk/tools"
fi

if [ -d "$DOTFILES/bin" ]; then
  export PATH="$PATH:$DOTFILES/bin"
fi

################################################################################
# Create PATH - END
################################################################################

################################################################################
# Handle optional imports - START
################################################################################

if [ -e "$DOTFILES/convenience_aliases.sh" ]; then
  source $DOTFILES/convenience_aliases.sh
fi

if [ -e "$DOTFILES/helper_functions.sh" ]; then
  source $DOTFILES/helper_functions.sh
fi

if hash HandBrakeCLI 2>/dev/null; then
  source $DOTFILES/handbrake_shortcuts.sh
fi

if hash ffmpeg 2>/dev/null; then
  source $DOTFILES/ffmpeg_shortcuts.sh
fi

if hash adb 2>/dev/null; then
  source $DOTFILES/android_shortcuts.sh
fi

if hash pyfiglet 2>/dev/null; then
  good_fonts=(dotmatrix epic big cola colossal contessa crazy cyberlarge doom graceful graffiti isometric3 jacky nancyj-improved nscript ogre puffy rounded shimrod standard stampate stampatello starwars stop straight utopia weird)
  alias print='pyfiglet -f ${good_fonts[$((RANDOM%${#good_fonts[*]}))]} -w $COLUMNS'
fi

if [ "$(uname)" == "Darwin" ]; then # You are using OS X
  source $DOTFILES/osx_shortcuts.sh
fi

if [ "$HOSTNAME" == "localhost" ]; then # You are most likely using termux
  source $DOTFILES/termux_shortcuts.sh
fi

if hash tree 2>/dev/null; then
  alias tt="tree -hpsDAFCQ --dirsfirst"
  alias lf="tt -P"
  alias lr="tt -a"
  alias ld="tt -a -d"
fi

# git aliases:
if hash git 2>/dev/null; then
  GIT_ENABLE=1
  source $DOTFILES/git_shortcuts.sh
  if [ -f $DOTFILES/git-completion.sh ]; then
    source $DOTFILES/git-completion.sh
  fi
fi

################################################################################
# Handle optional imports - END
################################################################################


################################################################################
# PS1 command
################################################################################

timer_start() {
    timer=${timer:-$SECONDS}
}

timer_stop() {
    timer_show=$(($SECONDS - $timer))
    unset timer
}

trap 'timer_start' DEBUG
PROMPT_COMMAND=timer_stop

git_status()
{
  branch="$(git branch 2> /dev/null | grep '*')"
  if [ $? -eq 0 ]; then
    branch="$(echo "$branch" | cut -d' ' -f2)"
    if [ "$branch" == "master" ]; then
      branch="M"
    fi
    echo " $branch"
  fi
}

git_file_count()
{
  branch="$(git branch 2> /dev/null)"
  if [ $? -eq 0 ]; then
    files_affected=" $(gf | wc -l | awk '{print $1}')"
    if [ "$files_affected" == " 0" ]; then
      files_affected=""
    fi
    echo "$files_affected"
  fi
}

print_time()
{
  if [ $timer_show -eq 0 ]; then
    echo ''
  else
    echo "$(printf "%2d" $timer_show) "
  fi
}

git_file_color()
{
  branch="$(git branch 2> /dev/null)"
  if [ $? -eq 0 ]; then
    files_affected="$(gf | wc -l | awk '{print $1}')"
    if [ "$files_affected" == "0" ]; then
      echo -e "\033[36m"
    else
      echo -e "\033[31m"
    fi
  fi
}

# \h = host
# \t = time
# \W = working directory
# \$ = mode
if [ $GIT_ENABLE ]; then
  export PS1='\[\e[31m\]$(print_time)\[\e[31m\]\[\e[35m\]\W\[$(git_file_color)\]$(git_status)\[\e[00m\] \$ '
else
  export PS1='\[\e[31m\]$(print_time)\[\e[31m\]\[\e[35m\]\W \[\e[00m\]\$'
fi
################################################################################
# PS1 command - END
################################################################################

if [ -f "$HOME/bashrc_private" ]; then
  source $HOME/bashrc_private
fi

