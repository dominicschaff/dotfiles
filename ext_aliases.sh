
alias cd..="cd .."
alias ls="ls -GpFh --color --group-directories-first"
alias l="ls"
alias ll="ls -l"
alias la="ll -a"
alias less='less -R -S -# 10'
alias curl="curl -w \"\\n\""
alias wget='wget -c'
alias code="cd $HOME/Code"
alias reload="source ~/.bashrc"
alias termsize='echo $COLUMNS x $LINES'
alias web="python3 -m http.server"

alias weather="curl 'http://wttr.in/cape_town'"
alias moon="curl 'http://wttr.in/Moon'"

alias f="declare -F | cut -d' ' -f'3-'"
alias h="type"

alias encrypt='openssl enc -aes-256-cbc -salt -in'
alias decrypt='openssl enc -d -aes-256-cbc -salt -in'

alias json="sed '/^[#////]/ d' | jq ."

alias exts='find . | while read f; do echo "${f##*.}"; done | sed "/^\s*$/d" | sort | uniq -c | sort -rn'

alias myip='curl -s "http://whatismyip.akamai.com"'



if hash tree 2>/dev/null; then
  alias tt="tree -hpsDAFCQ --dirsfirst"
  alias lf="tt -P"
  alias lr="tt -a"
  alias ld="tt -a -d"
fi