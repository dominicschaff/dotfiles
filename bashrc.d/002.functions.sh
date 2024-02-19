#!/usr/bin/env bash

key()
{
  pwgen -cnB ${1:-8}
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

line()
{
  printf '%*s\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' -
}

compress_dir()
{
  if [[ $# -eq 1 ]]; then
    echo "Compressing $1 to $1.tar.gz"
    tar cf - "$1" | pigz -9 > "$1.tar.gz"
  elif [[ $# -eq 2 ]]; then
    echo "Compressing $1 to $2"
    tar cf - "$1" | pigz -9 > "$2"
  else
    echo "Only 1 or 2 arguments are expected"
  fi
}

load_avg()
{
  uptime | rev | cut -d' ' -f1,2,3 | rev
}

filesize()
{
  for f in "$@"; do
    echo "$f => $(stat --printf="%B\n" "$f" | number_format)"
  done
}

dir_size()
{
  du -hsc .[^.]* * 2>/dev/null | sort -h
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
      *.tbz) tar -xvjf $1 ;;
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

open()
{
  if ! hash xdg-opn 2>/dev/null; then
    xdg-open "$1"
  elif ! hash termux-open 2>/dev/null; then
    termux-open "$1"
  fi
}

convert_extensions_to_lower_case()
{
  for f in *; do
    if [ -f "$f" ]; then
      extension="${f##*.}"
      filename="${f%.*}"
      extension_lower="$(echo "$extension" | tr '[:upper:]' '[:lower:]')"

      if [[ "$extension" != "$extension_lower" ]]; then
        echo "Moving: $f -> $filename.$extension_lower"
        mv "$f" "$filename.$extension_lower"
      fi
    fi
  done
}