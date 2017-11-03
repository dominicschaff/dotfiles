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
alias gh="git log -n 1 --pretty=format:\"%H\""
alias gl='git remote show origin -n | grep "Fetch URL:" | sed -E "s#^.*/(.*).*/(.*)\$#\1/\2#" | sed "s#.git\$##"'
alias aws_deploy="gl | pbcopy; read; gh | pbcopy"
alias gds="git diff --stat"

gn()
{
  if [ $# -eq 1 ]; then
    git checkout -b "$1"
    git push --set-upstream origin "$1"
  else
    echo "I only accept one argument"
  fi
}

gt()
{
  if [ $# -eq 1 ]; then
    git tag -a "v$1" -m "Creating tag $1"
  else
    echo "I only accept one argument"
  fi
}

bundle()
{
  if ! [ -d .git ]; then
    echo "This is not git repo or it's not the root"
    return
  fi
  repo_name="$(pwd | rev | cut -d'/' -f1 | rev).bundle"
  git bundle create "$repo_name" master
  echo "Created $repo_name"
}

unbundle()
{
  if [ -z "$1" ]; then
    echo "Need name"
    return
  fi
  if [ ! -f "$1" ]; then
    echo "File not exist"
    return
  fi
  git clone "$1" -b master
}