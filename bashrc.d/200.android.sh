#!/usr/bin/env bash

if ! hash adb 2>/dev/null; then
  return
fi

export PATH="$PATH:$ANDROID_HOME/tools/bin"


alias lc="adb logcat"
alias android_installed='adb shell "pm list packages -f" | cut -f 2 -d "=" | sort'
alias adb_refresh='adb shell am broadcast -a android.intent.action.MEDIA_MOUNTED -d file:///sdcard'

alias adb_home='adb shell input keyevent 3'
alias adb_back='adb shell input keyevent 4'
alias adb_volume_up='adb shell input keyevent 24'
alias adb_volume_down='adb shell input keyevent 25'
alias adb_camera='adb shell input keyevent 27'
alias adb_power='adb shell input keyevent 26'
alias adb_recents='adb shell input keyevent KEYCODE_APP_SWITCH'
alias adb_notification_open='adb shell service call statusbar 1'
alias adb_notification_close='adb shell service call statusbar 2'
alias adb_tab="adb shell input keyevent 61"
alias adb_enter="adb shell input keyevent 66"
alias adb_rotate_disable='adb shell settings put system accelerometer_rotation 0'
alias adb_rotate_enable='adb shell settings put system accelerometer_rotation 1'
alias adb_rotate_portrait='adb shell settings put system user_rotation 0'
alias adb_rotate_landscape='adb shell settings put system user_rotation 1'
alias adb_rotate_reverse_portrait='adb shell settings put system user_rotation 2'
alias adb_rotate_reverse_landscape='adb shell settings put system user_rotation 3'

alias adb_kill="adb shell am force-stop"
alias adb_clear="adb shell pm clear"

alias adb_tcp="adb tcpip 5555"
alias adb_wifi="adb connect"
alias adb_usb="adb usb"
alias adb_ip="adb shell ip route | awk '{print \$9}'"

alias adb_next='adb shell input keyevent 87'
alias adb_previous='adb shell input keyevent 88'
alias adb_play_pause='adb shell input keyevent 85'

adb_tap()
{
  adb shell input tap $1 $2
}

current_activity()
{
  adb shell dumpsys activity activities | grep "mFocusedActivity" | cut -d' ' -f6 | cut -d '/' -f2
}

wait_for_activity()
{
  while [[ "$(current_activity)" != "$1" ]]; do sleep 0.3; done
}

shot()
{
  adb shell screencap -p /sdcard/screen.png
  adb pull /sdcard/screen.png
  adb shell rm /sdcard/screen.png
  if [ $# -eq 1 ]; then
    mv screen.png "$1.png"
  else
    open screen.png
  fi
}

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

kbd()
{
  adb shell input text "'$@'"
}

adb_launch()
{
  for a in "$@"; do
    adb shell monkey -p "$a" -c android.intent.category.LAUNCHER 1
  done
}

div()
{
  while read -r line; do
    a="$line"
    b="$1"
    echo $((a/b))
  done
}

adb_battery()
{
  stats="$(adb shell dumpsys battery)"
  echo "$stats" | grep powered | grep -vi wireless | sed -e 's/^[ \t]*//'
  echo "Current voltage: $(echo "$stats" | grep 'voltage' | grep -v 'Max' | rev | cut -d' ' -f1 | rev) mV / $(echo "$stats" | grep 'Max charging voltage' | rev | cut -d' ' -f1 | rev | div 1000) mV"
  echo "Current current: $(echo "$stats" | grep 'current now' | rev | cut -d' ' -f1 | rev | div 1000) mA / $(echo "$stats" | grep 'Max charging current' | rev | cut -d' ' -f1 | rev | div 1000) mA"
  echo "Current level: $(echo "$stats" | grep 'Charge counter' | rev | cut -d' ' -f1 | rev | div 1000) mAh"
  echo "Battery level: $(echo "$stats" | grep 'level:' | rev | cut -d' ' -f1 | rev) % / $(echo "$stats" | grep 'scale:' | rev | cut -d' ' -f1 | rev) %"
  echo "Current temperature: $(echo "$stats" | grep 'temperature:' | rev | cut -d' ' -f1 | rev | div 10) °"
}

adb_device_stats()
{
  echo "Device Brand                    : $(adb shell getprop cda.skuid.brand)"
  echo "Device Name                     : $(adb shell getprop ro.product.model)"
  echo "Device Nickname                 : $(adb shell getprop ro.product.nickname)"
  echo "Device Country of Origin        : $(adb shell getprop cda.skuid.locale)"
  echo "Device CPU Core Type            : $(adb shell getprop dalvik.vm.isa.arm.variant)"
  echo "Device CPU Core Type 64bit      : $(adb shell getprop dalvik.vm.isa.arm64.variant)"
  echo "Device CPU Type                 : $(adb shell getprop ro.product.cpu.abilist)"

  echo "Network Type                    : $(adb shell getprop gsm.network.type)"
  echo "Network Name                    : $(adb shell getprop gsm.operator.alpha)"
  echo "Network Country                 : $(adb shell getprop gsm.operator.iso-country)"
  echo "Network Roaming                 : $(adb shell getprop gsm.operator.isroaming)"

  echo "Default SD Card                 : $(adb shell getprop persist.sys.sd.defaultpath)"
  echo "Device Timezone                 : $(adb shell getprop persist.sys.timezone)"
  echo "Device Locale                   : $(adb shell getprop ro.product.locale)"

  echo "Device Build Date               : $(adb shell getprop ro.build.date)"
  echo "Android Version                 : $(adb shell getprop ro.build.version.release)"
  echo "Android Version SDK             : $(adb shell getprop ro.build.version.sdk)"
  echo "Android Google Security Version : $(adb shell getprop ro.build.version.security_patch)"

  echo "Wifi Name                       : $(adb shell dumpsys netstats | grep -E 'iface=wlan.*networkId' | sort -u | cut -d'"' -f2)"
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

export ANDROID_HOME=~/Library/Android/sdk
