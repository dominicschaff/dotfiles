#!/usr/bin/env bash

if ! hash gource 2>/dev/null; then
  return
fi

my_gource()
{
    FRAME_RATE=30
    gource --load-config <(echo "[display]
frameless=true
no-vsync=true
output-framerate=$FRAME_RATE
output-ppm-stream=-
viewport=1920x1080

[gource]
background-colour=000000
bloom-intensity=0.2
bloom-multiplier=0.2
date-format=%Y %m %d
dir-name-depth=2
hide=mouse,progress,filenames
key=true
max-file-lag=0.1
stop-at-end=true
file-extensions=true
title=Mezzanine
seconds-per-day=0.1
") | ffmpeg -y -r $FRAME_RATE -f image2pipe -vcodec ppm -i - -vcodec libx264 -crf 18 -pix_fmt yuv420p -bf 0 "$HOME/Desktop/all_history_$(date +"%Y-%m-%d").mp4"
}
