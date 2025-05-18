#!/bin/bash

set -e

echo "🔧 Updating system..."
sudo apt update && sudo apt full-upgrade -y

echo "📦 Installing dependencies..."
sudo apt install -y alsa-utils curl pavucontrol wireplumber pipewire pipewire-audio-client-libraries libspa-0.2-bluetooth bluetooth bluez bluez-tools

echo "🧹 Removing PulseAudio-related packages (if present)..."
sudo apt remove -y pulseaudio pulseaudio-utils pulseaudio-module-bluetooth || true
rm -rf ~/.config/pulse

echo "🔁 Enabling PipeWire services..."
systemctl --user daemon-reexec
systemctl --user --now enable pipewire pipewire-pulse wireplumber

echo "🔊 Ensuring user is in audio and docker groups..."
sudo groupadd -f docker
sudo usermod -aG audio $USER
sudo usermod -aG docker $USER

echo "🐳 Installing Docker..."
curl -sSL https://get.docker.com | sh

echo "📶 Enabling and starting Bluetooth service..."
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

echo "🔗 Pairing and trusting Bluetooth devices..."

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

echo "✅ PipeWire is active, Bluetooth is configured, and Docker is ready."
echo "🔁 Please reboot to apply all changes."


