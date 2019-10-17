#!/usr/bin/env bash

if ! hash HandbrakeCLI 2>/dev/null; then
  return
fi

allConvert()
{
    for f in "$@"; do
        HandBrakeCLI -B 192 -e x264 -i "$f" -o "${f%.*}.m4v"
    done
}

allConvertN()
{
    for f in "$@"; do
        HandBrakeCLI -e x264 -i "$f" -o "${f%.*}.m4v"
    done
}
