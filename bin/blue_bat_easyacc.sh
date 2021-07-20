#!/bin/bash
ID="8A:04:21:B1:13:E8"

echo "Battery level of " `bluetoothctl info ${ID} | grep Name`

/opt/Bluetooth_Headset_Battery_Level/bluetooth_battery.py ${ID}
