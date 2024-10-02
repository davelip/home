#!/bin/sh

set -ex 

xrandr --addmode DP-2 "1920x1200"
xrandr --output DP-2 --mode 1920x1200 --rate 30
