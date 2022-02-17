#!/bin/sh

echo "video_cut.sh input output start end"

ffmpeg -ss $3 -i $1 -codec copy -t $4 $2
