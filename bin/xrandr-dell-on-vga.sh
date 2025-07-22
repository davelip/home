#!/bin/env bash

set -ex 

# $ cvt 1920 1200 60
# 1920x1200 59.88 Hz (CVT 2.30MA) hsync: 74.56 kHz; pclk: 193.25 MHz
# Modeline "1920x1200_60.00"  193.25  1920 2056 2256 2592  1200 1203 1209 1245 -hsync +vsync

# xrandr --listmonitors

xrandr --newmode "1920x1200_60.00"  193.25  1920 2056 2256 2592  1200 1203 1209 1245 -hsync +vsync
xrandr --addmode DP-2 "1920x1200_60.00"

# xrandr --output DP-2 --mode "1920x1200_60.00" --rate 60

# xrandr --delmode DP-2 1920x1200_60.00
# xrandr --rmmode "1920x1200_60.00"
