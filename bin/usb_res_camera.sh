#!/bin/bash
ID1="$1"
ID2="$2"

echo "Hard reset of USB " `lsusb -s ${ID1}:${ID2}`

sudo ~/bin/usbreset/usbreset /dev/bus/usb/${ID1}/${ID2}  
