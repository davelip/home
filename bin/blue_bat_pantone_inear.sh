#!/bin/bash
ID="6F:08:00:24:9B:3D"

echo "Battery level of " `bluetoothctl info ${ID} | grep Name`

/opt/Bluetooth_Headset_Battery_Level/bluetooth_battery.py ${ID}
