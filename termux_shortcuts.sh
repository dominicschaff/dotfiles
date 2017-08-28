
update()
{
  apt update
  
  if [ $(apt list --upgradable 2>/dev/null | wc -l) -ge 2 ];then
    apt upgrade
  fi
}

alias bat="termux-battery-status | jq '\"\(.percentage) : \(.temperature) (\(.status)|\(.plugged))\"'"
alias clean="apt autoremove"

status()
{
  date
  uptime
  echo "Battery: $(bat)"
}

alias pbcopy="termux-clipboard-set"
alias pbpaste="termux-clipboard-get"
