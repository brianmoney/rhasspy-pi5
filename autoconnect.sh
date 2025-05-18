#!/bin/bash

BTCTL=/usr/bin/bluetoothctl

# Bluetooth device MAC address (change if needed)
DEVICE1="DB:31:39:0C:DC:0F"
DEVICE2="64:31:39:0C:DC:0F"

# Bring up the Bluetooth adapter
bluetoothctl power on

# Trust both devices (optional, only needed once)
bluetoothctl trust $DEVICE1
bluetoothctl trust $DEVICE2

# Attempt to connect both (or just your primary)
bluetoothctl connect $DEVICE1
bluetoothctl connect $DEVICE2
