#!/usr/bin/env bash

# Terminal Options:
export HISTIGNORE="[ ]*"
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=-1
export HISTFILESIZE=-1
export CLICOLOR=1
export TIMEFORMAT='r: %R, u: %U, s: %S'

export DOTFILES="$HOME/dotfiles"
GIT_ENABLE=''

export PYTHONPATH="$PYTHONPATH:$HOME/dotfiles"

################################################################################
# Create PATH
################################################################################

if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/Library/Android/sdk/platform-tools" ]; then
  export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools"
fi

if [ -d "$HOME/Library/Android/sdk/tools" ]; then
  export PATH="$PATH:$HOME/Library/Android/sdk/tools"
fi

export PATH="$PATH:$DOTFILES/bin"

################################################################################
# Create PATH - END
################################################################################

################################################################################
# Handle optional imports - START
################################################################################

source $DOTFILES/ext_aliases.sh
source $DOTFILES/ext_functions.sh

if hash HandBrakeCLI 2>/dev/null; then
  source $DOTFILES/ext_handbrake.sh
fi

if hash ffmpeg 2>/dev/null; then
  source $DOTFILES/ext_ffmpeg.sh
fi

if hash adb 2>/dev/null; then
  source $DOTFILES/ext_android.sh
  export PATH="$PATH:$ANDROID_HOME/tools/bin"
fi

if hash awk 2>/dev/null; then
  source $DOTFILES/ext_awk.sh
fi

if [ "$(uname)" == "Darwin" ]; then # You are using OS X
  source $DOTFILES/ext_os_osx.sh
fi

if [ "$HOSTNAME" == "localhost" ]; then # You are most likely using termux
  source $DOTFILES/ext_os_termux.sh
fi

# git aliases:
if hash git 2>/dev/null; then
  GIT_ENABLE=1
  source $DOTFILES/ext_git.sh
  source $DOTFILES/git-completion.sh
fi

_ssh()
{
    local cur prev opts
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    opts=$(grep '^Host' ~/.ssh/config | grep -v '[?*]' | cut -d ' ' -f 2-)

    COMPREPLY=( $(compgen -W "$opts" -- ${cur}) )
    return 0
}
complete -F _ssh ssh

################################################################################
# Handle optional imports - END
################################################################################


################################################################################
# PS1 command
################################################################################
source $DOTFILES/ext_ps1.sh
################################################################################
# PS1 command - END
################################################################################

