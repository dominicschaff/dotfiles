#!/usr/bin/env bash

# Terminal Options:
export HISTCONTROL=ignoreboth:erasedups
HISTSIZE=1000000000
HISTFILESIZE=1000000000

# Convenience Functions:
alias cd..="cd .."
alias ls="ls -Gp --color --group-directories-first"
alias l="ls"
alias ll="ls -lh"

alias ym="youtube-dl -k -f bestvideo+bestaudio"
alias yr="ym -r 2M"

alias handn="HandBrakeCLI -Z \"Normal\" -e x264"
alias hand="HandBrakeCLI -Z \"Normal\" -B 192 -e x264"
alias less='less -R'
alias curl="curl -w \"\\n\""
alias p="python3"
alias lc="adb logcat"
alias web="java -jar ~/bin/WebServer.jar"

# Tree replaces ls:
alias tt="tree -hpsDAFCQ --dirsfirst"
alias lf="tt -P"
alias lr="tt -a"
alias ld="tt -a -d"
alias print='pyfiglet -f epic -w $COLUMNS'

alias s="scala"
alias sc="scalac"

# git aliases:
alias g="git status"
alias gp="git pull"
alias gc="git commit"
alias gg="git push"
alias gd="git diff"

alias wget='wget -c'

export TIMEFORMAT='r: %R, u: %U, s: %S'

alias top="top -F -R -o cpu"

convertUs()
{
  for i in *; do
    avconvert -s "$i" -o "${i%.*}.m4a" -p PresetAppleM4A &
    while [ $(jobs -p | wc -l) -ge 5 ]; do sleep 1; done;
  done
  wait
}

stitch()
{
    ffmpeg -i "$1" -i "$2" -c:v copy -c:a aac -strict experimental "$3"
}

convertMp4()
{
  for f in $1; do
    o="${f#*/}"
    echo "$f -> $2${o%.*}.mp4"
    ffmpeg -loglevel 0 -stats -i $f -qp 25 "$2${o%.*}.mp4"
  done
}

allConvert()
{
    for f in $1; do
        hand -i "$f" -o "${f%.*}.m4v"
    done
}

allConvertN()
{
    for f in $1; do
        handn -i "$f" -o "${f%.*}.m4v"
    done
}

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

stopMotion()
{
  if [ $# -eq 1 ]; then
    s="$1"
    o="out_8fps.mp4"
    f="8"
  elif [ $# -eq 2 ]; then
    s="$1"
    o="$2"
    f="8"
  else
    s="$2"
    o="$3"
    f="$1"
  fi
  ffmpeg -f image2 -r $f -i "$s" -r 30 "$o"
}

scale()
{
  ffmpeg -i $2 -vf scale=$1 $3
}

scale720()
{
  scale "trunc(oh*a/2)*2:720" $1 $2
}

scale1080()
{
  scale "trunc(oh*a/2)*2:1080" $1 $2
}

gifConvert()
{
    for f in *.gif; do
        ffmpeg -i "$f" -c:v libvpx -crf 12 -b:v 500K "${f%.*}.webm"
        hand -i "${f%.*}.webm" -o "${f%.*}.m4v"
        rm "${f%.*}.webm"
    done
}

pc()
{
  pandoc -s --standalone --toc -f markdown --highlight-style zenburn --template ~/dotfiles/pandoc/template.html -t html "$1" | sed 's/<table/<table class=\"table\"/' > "${1%.*}.html"
}

fetch_markdown()
{
  curl --data "read=1" --data "u=$1" "http://fuckyeahmarkdown.com/go/"
}

# Encrypt
alias encrypt='openssl des3 -salt -in'
# Decrypt
alias decrypt='openssl des3 -salt -d -in'

timer_start() {
    timer=${timer:-$SECONDS}
}

timer_stop() {
    timer_show=$(($SECONDS - $timer))
    unset timer
}

trap 'timer_start' DEBUG
PROMPT_COMMAND=timer_stop

export SCALA_HOME="$HOME/bin/scala"

export PATH="$HOME/bin:$PATH:$HOME/Library/Android/sdk/platform-tools:$SCALA_HOME/bin:$HOME/bin/activator/bin:$HOME/dotfiles/bin"

# \h = host
# \t = time
# \W = working directory
# \$ = mode
# \[\e[36m\[ = cyan
# \[\e[31m\[ = red
# \[\e[35m\[ = purple
# \[\e[34m\[ = blue
export PS1='\[\e[31m\]$(printf "%3d" $timer_show)\[\e[31m\]:\[\e[35m\]\W\[\e[34m\]> \[\e[00m\]'

