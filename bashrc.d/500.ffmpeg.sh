#!/usr/bin/env bash

if ! hash ffmpeg 2>/dev/null; then
  return
fi

alias ffmpeg="ffmpeg -loglevel 0 -stats"

stitch()
{
    ffmpeg -i "$1" -i "$2" -c:v copy -c:a aac -strict experimental "$3"
}

convertMp4()
{
  for f in "$@"; do
    o="${f#*/}"
    echo "$f -> ${o%.*}.mp4"
    ffmpeg -i "$f" -vcodec libx264 -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" -pix_fmt yuv420p -qp 25 "${o%.*}.mp4"
  done
}

convertH265()
{
  for f in "$@"; do
    o="${f#*/}"
    echo "$f -> ${o%.*}.h265.mp4"
    ffmpeg -i "$f" -c:v libx265 -preset medium -crf 28 -c:a aac -b:a 128k "$o.h265.mp4"
  done
}

convertAAC()
{
  for f in "$@"; do
    ffmpeg -i "$f" -c:a aac -b:a 192k "${f%.*}.m4a"
  done
}

convertFlacLow()
{
  for f in "$@"; do
    ffmpeg -i "$f" -af aformat=s16:44100 "${f%.*}.flac"
  done
}

convertFlacHigh()
{
  for f in "$@"; do
    ffmpeg -i "$f" -af aformat=s32:176000 "${f%.*}.flac"
  done
}

stopMotion()
{
  if [ $# -eq 1 ]; then
    s="$1"
    o="out_8fps.mp4"
    f="8"
  elif [ $# -eq 2 ]; then
    s="$1"
    o="$2"
    f="8"
  else
    s="$2"
    o="$3"
    f="$1"
  fi
  ffmpeg -f image2 -r $f -i "$s" -r 30 "$o"
}

scale()
{
  ffmpeg -i "$2" -vf scale=$1 "$3"
}

scale480()
{
  scale "trunc(oh*a/2)*2:480" "$1" "$2"
}

scale720()
{
  scale "trunc(oh*a/2)*2:720" "$1" "$2"
}

scale1080()
{
  scale "trunc(oh*a/2)*2:1080" "$1" "$2"
}

stop_motion_complete_1080()
{
  if [ $# -eq 2 ]; then
    echo "Using $1 to create $2"
  else
    echo "More arguments are required: $0 <file glob> <output name>"
    return
  fi
  i=1
  for f in $1; do
    echo "$f"
    scale1080 "$f" "scaled-$(printf "%03d" $i).jpg"
    i=$((i+1))
  done
  stopMotion 8 "scaled-%3d.jpg" "temp-8.mp4"
  stopMotion 15 "scaled-%3d.jpg" "temp-15.mp4"
  stopMotion 24 "scaled-%3d.jpg" "temp-24.mp4"
  stopMotion 30 "scaled-%3d.jpg" "temp-30.mp4"
  ffmpeg -i "temp-8.mp4" -vcodec libx264 -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" -pix_fmt yuv420p -qp 25 "$2p-8.mp4"
  ffmpeg -i "temp-15.mp4" -vcodec libx264 -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" -pix_fmt yuv420p -qp 25 "$2-15.mp4"
  ffmpeg -i "temp-24.mp4" -vcodec libx264 -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" -pix_fmt yuv420p -qp 25 "$2-24.mp4"
  ffmpeg -i "temp-30.mp4" -vcodec libx264 -vf "pad=ceil(iw/2)*2:ceil(ih/2)*2" -pix_fmt yuv420p -qp 25 "$2-30.mp4"
  rm scaled-*.jpg temp-*.mp4
}

gifConvert()
{
    for f in *.gif; do
        ffmpeg -i "$f" -c:v libvpx -crf 12 -b:v 500K "${f%.*}.webm"
        convertMp4 "${f%.*}.webm"
        rm "${f%.*}.webm"
    done
}

gifenc()
{
  palette="/tmp/palette.png"
  ffmpeg -v warning -i $1 -vf "palettegen" -y $palette
  ffmpeg -v warning -i $1 -i $palette -lavfi "paletteuse" -y $2
}

convertMp3()
{
  for f in "$@"; do
    ffmpeg -i "$f" -q:a 3 "${f%.*}.mp3"
  done
}

convertWebm()
{
  for f in "$@"; do
    ffmpeg -i "$f" -c:v libvpx-vp9 "${f%.*}.webm"
  done
}

convertWebmLow()
{
  for f in "$@"; do
    ffmpeg -i "$f" -c:v libvpx-vp9 -crf 33 -b:v 0 "${f%.*}.webm"
  done
}

convertCut()
{
  if [[ $# -eq 4 ]]; then
    ffmpeg -i "$1" -ss $2 -to $3 $SETTINGS "$4"
  elif [ $# -eq 3 ]; then
    ffmpeg -i "$1" -ss $2 $SETTINGS "$3"
  else
    echo "Not enough arguments:"
    echo "$0 <INPUT> <START> [<END>] <OUTPUT>"
  fi
}

convertLow()
{
  mkdir -p "output"
  settings="-preset veryfast -vcodec libx264 -pix_fmt yuv420p -crf 20"
  for f in "$@"; do
    echo "$(date +%T) -> $f"
    output="$(dirname "$f")/output/$(basename "$f")"
    crop="$(\ffmpeg -i "$f" -vf cropdetect -f null - 2>&1 | awk '/crop/ { print $NF }' | tail -1)"
    if [[ "${crop: -3}" = "0:0" ]]; then
      echo -e "\e[36mno crop found\e[0m -> $crop"
      ffmpeg -loglevel 0 -stats -i "$f" $settings "$output"
    else
      echo -e "\e[36mcropping\e[0m -> $crop"
      ffmpeg -loglevel 0 -stats -i "$f" $settings -vf $crop "$output"
    fi
    a="$(stat --printf="%s\n" "$f")"
    b="$(stat --printf="%s\n" "$output")"
    fs="$((100*b/a))"
    if [[ $fs -ge 100 ]]; then
      echo -e "compressed to \e[31m$fs %\e[0m -> $(echo "$b" | nft)"
    else
      echo -e "compressed to \e[32m$fs %\e[0m -> $(echo "$b" | nft)"
    fi
  done
}

get_crop()
{
  \ffmpeg -i "$1" -t 1 -vf cropdetect -f null - 2>&1 | awk '/crop/ { print $NF }' | tail -1
}

shrink_1080()
{
  crop="$(\ffmpeg -i "$1" -vf cropdetect -f null -t 60 - 2>&1 | awk '/crop/ { print $NF }' | tail -1)"

  if [[ "${crop: -3}" = "0:0" ]]; then
    echo -e "\e[36mno crop found\e[0m -> $crop"
    \ffmpeg -i "$1" -c:v libx265 -preset veryfast -crf 20 -c:a copy -vf "scale='min(1920,iw)':-2" "$2"
  else
    echo -e "\e[36mcropping\e[0m -> $crop"
    \ffmpeg -i "$1" -c:v libx265 -preset veryfast -crf 20 -c:a copy -vf "scale='min(1920,iw)':-2" -vf $crop "$2"
  fi
}

shrink_1080mp4()
{
  ffmpeg -i "$1" -preset veryfast -crf 20 -c:a copy -vf "scale=-2:'min(1080,ih)'" "$2"
}

shrink_1920mp4()
{
  ffmpeg -i "$1" -preset veryfast -crf 20 -c:a copy -vf "scale='min(1920,iw)':-2" "$2"
}

overlay()
{
  ffmpeg -i "$1" -i "$2" -filter_complex "overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2" "$3"
}

