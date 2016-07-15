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