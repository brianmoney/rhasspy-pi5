#!/bin/bash

set -e

echo "Updating system..."
sudo apt update && sudo apt full-upgrade -y

echo "Installing dependencies..."
sudo apt install -y alsa-utils pulseaudio curl

sudo groupadd -f docker         # Add this line to ensure the docker group exists
sudo usermod -aG audio $USER
sudo usermod -aG docker $USER

# ...existing code...
sudo usermod -aG audio $USER
sudo usermod -aG docker $USER

echo "Installing Docker..."
curl -sSL https://get.docker.com | sh

echo "Enabling PulseAudio for current user..."
systemctl --user enable pulseaudio
systemctl --user start pulseaudio

echo "Creating PulseAudio socket directory..."
mkdir -p ~/.config/pulse
PULSE_SOCKET="/run/user/$(id -u)/pulse/native"
echo "PULSE_SOCKET path is $PULSE_SOCKET"

echo "Installing Bluetooth utilities..."
sudo apt install -y bluetooth bluez bluez-tools

echo "Enabling and starting Bluetooth service..."
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

echo "Pairing and trusting Bluetooth devices..."

bluetoothctl << EOF
power on
agent on
default-agent
scan on
pair DB:31:39:0C:DC:0F
trust DB:31:39:0C:DC:0F
pair 64:31:39:0C:DC:0F
trust 64:31:39:0C:DC:0F
scan off
exit
EOF


echo "DONE. Reboot required to apply all changes."
