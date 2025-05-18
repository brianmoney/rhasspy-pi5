#!/bin/bash

set -e

echo "Updating system..."
sudo apt update && sudo apt full-upgrade -y

echo "Installing dependencies..."
sudo apt install -y alsa-utils pulseaudio curl

echo "Adding user to audio and docker groups..."
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

echo "DONE. Reboot required to apply all changes."
