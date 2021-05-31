#!/usr/bin/env bash

if ! hash adb 2>/dev/null; then
  return
fi

export ANDROID_HOME=~/Library/Android/sdk
export PATH="$PATH:$ANDROID_HOME/tools/bin"

pull()
{
  for a in "$@"; do
    adb pull "$a"
  done
}

push()
{
  for a in "$@"; do
    adb push "$a" /sdcard/
  done
}

open_urls()
{
  c=""
  output="$(adb devices)"
  if [[ "$(echo "$output" | wc -l)" -gt 3 ]]; then
    if echo "$output" | grep -iq "$1"; then
      c="-s $1"
      shift 1
    else
      echo "A device needs to be specified as the first argument"
      return 1
    fi
  fi
  for f in "$@";do
    adb $c shell am start -a android.intent.action.VIEW "'$f'"
  done
}

download_all_apks()
{
  for i in $(adb shell pm list packages | awk -F':' '{print $2}'); do
    echo "Fetching : $i"
    adb pull "$(adb shell pm path $i | awk -F':' '{print $2}')"
    mv base.apk $i.apk
  done
}
