alias ffmpeg="ffmpeg -loglevel 0 -stats"

stitch()
{
    ffmpeg -loglevel 0 -stats -i "$1" -i "$2" -c:v copy -c:a aac -strict experimental "$3"
}

convertMp4()
{
  for f in $1; do
    o="${f#*/}"
    echo "$f -> $2${o%.*}.mp4"
    ffmpeg -i $f -qp 25 "$2${o%.*}.mp4"
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
  ffmpeg -i $2 -vf scale=$1 $3
}

scale720()
{
  scale "trunc(oh*a/2)*2:720" $1 $2
}

scale1080()
{
  scale "trunc(oh*a/2)*2:1080" $1 $2
}

stop_motion_complete_1080()
{
  if [ $# -eq 2 ]; then
    echo "Using $1 to create $2"
  else
    echo "More arguments are required: stop_motion_complete_1080 <file glob> <output name>"
  fi
  i=1
  for f in $1; do
    echo "$f"
    scale1080 "$f" "scaled-$(printf "%03d" $i).jpg"
    i=$((i+1))
  done
  stopMotion 8 "scaled-%3d.jpg" "$2-8.mp4"
  stopMotion 15 "scaled-%3d.jpg" "$2-15.mp4"
  stopMotion 24 "scaled-%3d.jpg" "$2-24.mp4"
  stopMotion 30 "scaled-%3d.jpg" "$2-30.mp4"
  hand -i "$2-8.mp4" -o "$2-8.mp4"
  hand -i "$2-15.mp4" -o "$2-15.m4v"
  hand -i "$2-24.mp4" -o "$2-24.m4v"
  hand -i "$2-30.mp4" -o "$2-30.m4v"
  rm scaled-*.jpg
}

gifConvert()
{
    for f in *.gif; do
        ffmpeg -i "$f" -c:v libvpx -crf 12 -b:v 500K "${f%.*}.webm"
        hand -i "${f%.*}.webm" -o "${f%.*}.m4v"
        rm "${f%.*}.webm"
    done
}

gifenc()
{
  palette="/tmp/palette.png"
  ffmpeg -v warning -i $1 -vf "palettegen" -y $palette
  ffmpeg -v warning -i $1 -i $palette -lavfi "paletteuse" -y $2
}
