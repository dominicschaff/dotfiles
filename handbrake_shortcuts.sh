alias hand="HandBrakeCLI -Z \"Normal\" -B 192 -e x264"
alias handn="HandBrakeCLI -Z \"Normal\" -e x264"

allConvert()
{
    for f in $1; do
        hand -i "$f" -o "${f%.*}.m4v"
    done
}

allConvertN()
{
    for f in $1; do
        handn -i "$f" -o "${f%.*}.m4v"
    done
}
