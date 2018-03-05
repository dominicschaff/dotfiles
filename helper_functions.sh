

key()
{
  pwgen -cnB ${1:-8}
}

password()
{
  pwgen -cnyB ${1:-15}
}

find_size()
{
  find . -iname "$1" -exec du -kc {} + | grep total$ | cut -f1 | awk '{ sum+=$1} END {print sum*1024}' | nft
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
    cd $HOME/tmp
  else
    if [ -d "$TMPDIR" ]; then
      cd $TMPDIR
    else
      cd /tmp
    fi
  fi
  pwd
}

qr_code()
{
  qr "$1" > "$1.png"
  open "$1.png"
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

err()
{
  echo "[$(date +'%Y-%m-%d %T')]: $@" >&2
}

tlog()
{
  echo "[$(date +'%Y-%m-%d %T')]: $@"
}

output_zip()
{
  cat - > "$1.csv"
  zip "$1.zip" "$1.csv"
  rm "$1.csv"
}

pip3_install()
{
  pip3 install --user awscli paho-mqtt pg8000 Pillow qrcode youtube-dl aws-shell pyfiglet Pygments
}

pip3_update()
{
  pip3 list --user | tail -n+3 | cut -d' ' -f1 | while read pck; do
    pip3 install --upgrade --user "$pck"
  done

}

pip3_update_global()
{
  pip3 list | tail -n+3 | cut -d' ' -f1 | while read pck; do
    pip3 install --upgrade "$pck"
  done
}

last_monday()
{
  date -dlast-monday +%Y-%m-%d
}

last_sunday()
{
  date -dlast-sunday +%Y-%m-%d
}