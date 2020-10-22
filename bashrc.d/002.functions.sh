#!/usr/bin/env bash

key()
{
  pwgen -cnB ${1:-8}
}

password()
{
  pwgen -cnyB ${1:-15}
}

pc()
{
  pandoc -s --standalone --toc -f markdown --highlight-style zenburn --template ~/dotfiles/pandoc/template.html -t html "$1" | sed 's/<table/<table class=\"table\"/' > "${1%.*}.html"
}

pc_print()
{
  pandoc -s --standalone --toc -f markdown --highlight-style haddock --template ~/dotfiles/pandoc/template.html -t html "$1" | sed 's/<table/<table class=\"table\"/' > "${1%.*}.html"
}

fetch_markdown()
{
  curl --data "read=1" --data "u=$1" "http://fuckyeahmarkdown.com/go/"
}

convertTime()
{
  date -d @$(echo $1) +"%Y-%m-%d %T"
}

convertMilli()
{
  convertTime $(echo $1 | rev | cut -c 4- | rev)
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

tmp()
{
  if [ -d "$HOME/tmp" ]; then
    cd "$HOME/tmp"
  else
    if [ -d "$TMPDIR" ]; then
      cd "$TMPDIR"
    else
      cd /tmp
    fi
  fi
  pwd
}

tm()
{
  convertMilli $1 | pbcopy
}

t()
{
  convertTime $1 | pbcopy
}

line()
{
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

last_monday()
{
  date -d'last week last monday' +%Y-%m-%d
}

last_sunday()
{
  date -d'last sunday' +%Y-%m-%d
}

get_ip_for_host()
{
  for f in "$@"; do
    echo "$f"
    answer="$(curl -s "https://1.1.1.1/dns-query?ct=application/dns-json&name=$f")"
    if [[ "$(echo "$answer" | jq -r '.Status')" == "0" ]]; then
      echo "$answer" | jq -r '.Answer[] | .data' | sort -u
    else
      echo "Error finding IP:"
      echo "$answer"
    fi
  done
}

compress_dir()
{
  tar -cv $1/ | gzip -9 > archive.tar.gz
}

load_avg()
{
  uptime | rev | cut -d' ' -f1,2,3 | rev
}

filesize()
{
  for f in "$@"; do
    echo "$f => $(stat --printf="%B\n" "$f" | nft)"
  done
}

get_tweets()
{
  curl -s "https://twitrss.me/twitter_user_to_rss/?user=$1" | xq '.rss.channel.item[]' | jq -c .
}

get_random_tweet()
{
  get_tweets $1 | sort -R | head -n1 | jq -r '.title'
}

timestamp()
{
  if [[ $# -eq 0 ]]; then
    date "+%s"
  else
    for d in "$@"; do
      s="$d"
      if [[ ${#s} -gt 10 ]]; then
        s="$(echo $d | rev | cut -c 4- | rev)"
      fi
      date -d @$s +"%Y-%m-%d %T"
    done
  fi
}

do_merge()
{
  filename=$(basename -- "$1")
  extension="${filename##*.}"
  filename="${filename%.*}"
  base="$1"
  convert $@ -background black -flatten "output.$extension"
}

title()
{
  PROMPT_COMMAND="echo -ne \"\033]0;$*\007\""
}

dir_size()
{
  du -hsc * 2>/dev/null | sort -h
}

do_we_have_internet()
{
  while true; do
    ping -c 1 -t 3 google.com > /dev/null
    if [[ $? == 0 ]]; then
      echo 'We are connected'
      say "We have the internets"
      return
    else
      echo "No internet"
    fi
    sleep 5
  done
}

mirror()
{
  wget \
    --mirror \
    --recursive \
    --convert-links \
    --adjust-extension \
    --span-hosts \
    --page-requisites \
    --no-parent \
    --quiet \
    --show-progress \
    "$1"
}

fib()
{
  n=$1
  if [[ $n -lt 2 ]]; then
    echo $n
    return
  fi
  a=0
  b=1
  c=$((a+b))
  for (( i = 1; i < n; i++ )); do
    c=$((a+b))
    a=$b
    b=$c
  done
  echo $c
}

scratch()
{
  if [ ! -f ~/scratch.md ]; then
    touch ~/scratch.md
  fi

  vim ~/scratch.md
}

ex()
{
  if [ -f $1  ]; then
    case $1 in
      *.tar.bz2) tar xjf $1 ;;
      *.tar.gz) tar xzf $1 ;;
      *.bz2) bunzip2 $1 ;;
      *.rar) unrar x $1 ;;
      *.gz) gunzip $1 ;;
      *.tar) tar xf $1 ;;
      *.tbz2) tar xjf $1 ;;
      *.tgz) tar xzf $1 ;;
      *.zip) unzip $1 ;;
      *.Z) uncompress $1 ;;
      *.7z) 7z x $1 ;;
      *.deb) ar x $1 ;;
      *.tar.xz) tar xf $1 ;;
      *.tar.zst) unzstd $1 ;;
      *) echo "'$1' cannot be extracted via ex()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

