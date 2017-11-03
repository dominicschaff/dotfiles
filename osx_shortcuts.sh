alias top="top -F -R -o cpu"

notify()
{
  if [ $# -eq 1  ]; then
    osascript -e "display notification \"$1\" with title \"Notification\""
  elif [ $# -eq 2  ]; then
    osascript -e "display notification \"$2\" with title \"$1\""
  elif [ $# -eq 3  ]; then
    osascript -e "display notification \"$3\" with title \"$1\"  subtitle \"$2\""
  else
    echo "Can only be run with 1/2/3 arguments"
  fi
}

play()
{
  if [ $# -eq 1 ]; then
    for i in $1; do
      echo "Playing: $i"
      afplay "$i"
    done
  else
    echo "1 argument expected"
  fi
}

play_random()
{
  find . -iname "*.mp3" | sort -R | while read a; do echo "$a"; afplay "$a"; done
}

convertUs()
{
  for i in *; do
    avconvert -s "$i" -o "${i%.*}.m4a" -p PresetAppleM4A &
    while [ $(jobs -p | wc -l) -ge 5 ]; do sleep 1; done;
  done
  wait
}

update()
{
  brew update
  brew upgrade
}