#!/bin/bash
ID="FC:A8:9A:00:2C:23"

echo "Battery level of " `bluetoothctl info ${ID} | grep Name`

/opt/Bluetooth_Headset_Battery_Level/bluetooth_battery.py ${ID}
