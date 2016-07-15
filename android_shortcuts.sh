
alias lc="adb logcat"

shot()
{
  adb shell screencap -p /sdcard/screen.png
  adb pull /sdcard/screen.png
  adb shell rm /sdcard/screen.png
  if [ $# -eq 1 ]; then
    mv screen.png $1.png
  else
    open screen.png
  fi
}

pull()
{
  adb pull "$1"
}

push()
{
  adb push "$1" "/sdcard/$(basename "$1")"
}