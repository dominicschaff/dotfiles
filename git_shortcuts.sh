alias g="git status"
alias gp="git pull"
alias gc="git commit"
alias gcm="git commit -m"
alias gcam="git commit -am"
alias gg="git push"
alias ggt="gg --tags"
alias gd="git diff"
alias glogs="git log --oneline --decorate --color --graph --stat"
alias glog="git log --oneline --decorate --color --graph"
alias master="git checkout master; git remote update -p; gp"
alias gf="git status --porcelain"
alias gh="git log -n 1 --pretty=format:\"%H\""
alias gl='git remote show origin -n | grep "Fetch URL:" | sed -E "s#^.*/(.*).*/(.*)\$#\1/\2#" | sed "s#.git\$##"'
alias aws_deploy="gl | pbcopy; read; gh | pbcopy"

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

