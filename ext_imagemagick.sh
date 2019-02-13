cut_3_screens()
{
  for f in "$@"; do
    s="$(img_size "$f")"
    if [[ "$s" == "6000x4000" ]]; then
      convert "$f" -crop 3000x2000+0+0 "${f%.*}_top_left.jpg"
      convert "$f" -crop 3000x2000+3000+0 "${f%.*}_top_right.jpg"
      convert "$f" -crop 3000x2000+1500+2000 "${f%.*}_bottom_center.jpg"
    else
      echo "$f is the wrong size. It is '$s' but is required to be '6000x4000'"
    fi
  done
}

cut_4_screens()
{
  for f in "$@"; do
    s="$(img_size "$f")"
    if [[ "$s" == "6000x4000" ]]; then
      convert "$f" -crop 3000x2000+0+0 "${f%.*}_top_left.jpg"
      convert "$f" -crop 3000x2000+3000+0 "${f%.*}_top_right.jpg"
      convert "$f" -crop 3000x2000+0+2000 "${f%.*}_bottom_left.jpg"
      convert "$f" -crop 3000x2000+3000+2000 "${f%.*}_bottom_right.jpg"
    else
      echo "$f is the wrong size. It is '$s' but is required to be '6000x4000'"
    fi
  done
}

img_size()
{
  if [[ $# -eq 1 ]]; then
    identify "$1"  | cut -d' ' -f3
  else
    for f in "$@"; do
      echo "$f -> $(identify "$f"  | cut -d' ' -f3)"
    done
  fi
}