#!/usr/bin/env bash

# Terminal Options:
export HISTCONTROL=ignoreboth:erasedups
HISTSIZE=-1
HISTFILESIZE=-1
export CLICOLOR=1
export TIMEFORMAT='r: %R, u: %U, s: %S'

DOTFILES="$HOME/dotfiles"
GIT_ENABLE=''

################################################################################
# Create PATH
################################################################################

if [ -d "$HOME/bin" ]; then
  export PATH="$HOME/bin:$PATH"
fi

if [ -d "$HOME/Library/Android/sdk/platform-tools" ]; then
  export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools"
fi

if [ -d "$DOTFILES/bin" ]; then
  export PATH="$PATH:$DOTFILES/bin"
fi

################################################################################
# Create PATH - END
################################################################################

# Convenience Functions:
alias cd..="cd .."
alias ls="ls -GpFh --color --group-directories-first"
alias l="ls"
alias ll="ls -l"
alias la="ll -a"
alias less='less -R'
alias curl="curl -w \"\\n\""
alias wget='wget -c'

alias print='pyfiglet -f epic -w $COLUMNS'

alias weather="curl 'http://wttr.in/cape_town'"
alias moon="curl 'http://wttr.in/Moon'"

alias f="declare -F | cut -d' ' -f'3-'"
alias h="type"

alias encrypt='openssl des3 -salt -in'
alias decrypt='openssl des3 -salt -d -in'

if hash youtube-dl 2>/dev/null; then
  alias ym="youtube-dl -k -f bestvideo+bestaudio"
  alias yr="ym -r 2M"
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

if [ "$(uname)" == "Darwin" ]; then # You are using OS X
  source $DOTFILES/osx_shortcuts.sh
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
  alias g="git status"
  alias gp="git pull"
  alias gc="git commit"
  alias gcm="git commit -m"
  alias gcam="git commit -am"
  alias gg="git push"
  alias gd="git diff"
  alias glogs="git log --oneline --decorate --color --graph --stat"
  alias glog="git log --oneline --decorate --color --graph"
  alias master="git checkout master; git remote update -p; gp"
  alias gf="git status --porcelain"
  if [ -f $DOTFILES/git-completion.sh ]; then
    source $DOTFILES/git-completion.sh
  fi
fi

key()
{
  amount=8
  if [ $# -eq 1 ]; then
    amount=$1
  fi
  python -c "import random; print''.join(['1234567890abcdefghijklmnopqrstuvwxyz'[random.randint(0, 35)] for x in xrange($amount)])"
}

password()
{
  amount=8
  if [ $# -eq 1 ]; then
    amount=$1
  fi
  python -c "import random; print''.join(['1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!._-'[random.randint(0, 66)] for x in xrange($amount)])"
}

pc()
{
  pandoc -s --standalone --toc -f markdown --highlight-style zenburn --template ~/dotfiles/pandoc/template.html -t html "$1" | sed 's/<table/<table class=\"table\"/' > "${1%.*}.html"
}

fetch_markdown()
{
  curl --data "read=1" --data "u=$1" "http://fuckyeahmarkdown.com/go/"
}

exts()
{
  for f in *; do
    filename=$(basename "$f")
    echo "${filename##*.}"
  done | uniq -c
}

print_all_them_colors()
{
  for x in 0 1 4 5 7 8; do
    for i in `seq 30 37`; do
      for a in `seq 40 47`; do
        echo -ne "\e[$x;$i;$a""m\\\e[$x;$i;$a""m\e[0;37;40m "
      done
      echo
    done
  done
  echo ""
}

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
    echo "$branch"
  fi
}

git_file_count()
{
  branch="$(git branch 2> /dev/null)"
  if [ $? -eq 0 ]; then
    files_affected="($(gf | wc -l | awk '{print $1}'))"
    if [ "$files_affected" == "(0)" ]; then
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

# \h = host
# \t = time
# \W = working directory
# \$ = mode
# \e[36m = cyan
# \e[31m = red
# \e[35m = purple
# \e[34m = blue
if [ $GIT_ENABLE ]; then
  export PS1='\[\e[31m\]$(print_time)\[\e[31m\]\[\e[35m\]\W \[\e[36m\]$(git_status)\[\e[31m\]$(git_file_count)\[\e[32m\]: \[\e[00m\]'
else
  export PS1='\[\e[31m\]$(print_time)\[\e[31m\]\[\e[35m\]\W \[\e[32m\]: \[\e[00m\]'
fi
################################################################################
# PS1 command - END
################################################################################

if [ -f "$HOME/bashrc_private" ]; then
  source $HOME/bashrc_private
fi

