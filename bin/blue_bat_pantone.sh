#!/bin/bash
ID="41:42:46:38:DA:16"

echo "Battery level of " `bluetoothctl info ${ID} | grep Name`

/opt/Bluetooth_Headset_Battery_Level/bluetooth_battery.py ${ID}
