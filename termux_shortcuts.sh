
update()
{
  apt update
  
  if [ $(apt list --upgradable 2>/dev/null | wc -l) -ge 2 ];then
    apt upgrade
  fi
}
