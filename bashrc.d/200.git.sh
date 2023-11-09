#!/usr/bin/env bash

if ! hash git 2>/dev/null; then
  return
fi

alias g="git status"
alias gp="git pull"
alias gcm="git commit -S -m"
alias gcam="git commit -S -am"
alias gg="git push"
alias gd="git diff --color-words"
alias glogs="git log --oneline --decorate --color --graph --stat"
alias glog="git log --oneline --decorate --color --graph --all"
alias glogdiff="git log -p --color --full-diff"
alias gf="git status --porcelain"
alias aws_deploy="gl | pbcopy; read; gh | pbcopy"
alias gds="git diff --stat"
alias gb="cd \$(git rev-parse --show-toplevel)"
alias gr="git remote -v"

gi()
{
  echo "$(git branch 2> /dev/null | grep '*' | cut -d' ' -f2-) : $(git status --porcelain | wc -l)"
}

rebase()
{
  if git branch | grep -q main; then
    git rebase -i main
  elif git branch | grep -q master; then
    git rebase -i master
  else
    echo "Unknown git main branch"
  fi
}

gm()
{
  if git branch | grep -q main; then
    git checkout main
    git pull
  elif git branch | grep -q master; then
    git checkout master
    git pull
  else
    echo "Unknown git main branch"
  fi
}

gn()
{
  if [[ $# -eq 1 ]]; then
    git checkout -b "$1"
    git push --set-upstream origin "$1"
  else
    echo "I only accept one argument"
  fi
}

gt()
{
  if [[ $# -eq 1 ]]; then
    git tag -a "v$1" -m "Creating tag $1"
  else
    echo "Latest tags"
    git tag | tail
  fi
}

bundle()
{
  if ! [[ -d .git ]]; then
    echo "This is not git repo or it's not the root"
    return
  fi
  repo_name="$(pwd | rev | cut -d'/' -f1 | rev).bundle"
  git bundle create "$repo_name" "$(git branch | grep '*' | cut -d' ' -f2)"
  echo "Created $repo_name"
}

unbundle()
{
  if [[ -z "$1" ]]; then
    echo "Need name"
    return
  fi
  if [[ ! -f "$1" ]]; then
    echo "File not exist"
    return
  fi
  git clone "$1" -b master
}

record_history_to_video()
{
  output="$HOME/gource.mp4"
  if [[ -n "$1" ]]; then
    output="$1"
  fi
  gource -1920x1080 -o - | ffmpeg -y -r 60 -f image2pipe -vcodec ppm -i - -vcodec libx264 -preset ultrafast -pix_fmt yuv420p -crf 1 -threads 0 -bf 0 "$output"
}
