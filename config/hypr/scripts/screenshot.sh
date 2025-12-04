#!/bin/bash

DIR=$HOME/Pictures/Screenshots
FILENAME="$(date '+%Y-%m-%d_%H-%m-%S-%N.png')"
FILEPATH="$DIR/$FILENAME"

MESSAGE_CLIP="Screenshot is taken"
MESSAGE_FILE="Screenshot is taken: $FILENAME"

SRC_SCREEN=0
SRC_SELECT=1

DST_FILE=0
DST_CLIP=1

SRC=$SRC_SCREEN
DST=$DST_FILE

for arg in "$@"; do
    case $arg in
    "--select" | "-s") SRC=$SRC_SELECT ;;
    "--clip" | "-c") DST=$DST_CLIP ;;
    *)
        echo No args
        ;;
    esac
done

mkdir -p $DIR

[[ $SRC -eq $SRC_SCREEN && $DST -eq $DST_FILE ]] && grim -t png -l 0 - >$FILEPATH && notify-send "$MESSAGE_FILE"
[[ $SRC -eq $SRC_SCREEN && $DST -eq $DST_CLIP ]] && grim -t png -l 0 - | wl-copy && notify-send "$MESSAGE_CLIP"
[[ $SRC -eq $SRC_SELECT && $DST -eq $DST_FILE ]] && GEOMETRY="$(slurp)" && grim -t png -l 0 -g "$GEOMETRY" - >$FILEPATH && notify-send "$MESSAGE_FILE"
[[ $SRC -eq $SRC_SELECT && $DST -eq $DST_CLIP ]] && GEOMETRY="$(slurp)" && grim -t png -l 0 -g "$GEOMETRY" - | wl-copy && notify-send "$MESSAGE_CLIP"
