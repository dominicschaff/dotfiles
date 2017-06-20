alias kbd="adb shell input text"
alias lc="adb logcat"
alias installed="adb shell 'pm list packages -f' | grep '/data/app/' | sort"
alias adb_refresh='adb shell am broadcast -a android.intent.action.MEDIA_MOUNTED -d file:///sdcard'
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

export ANDROID_HOME=~/Library/Android/sdk
