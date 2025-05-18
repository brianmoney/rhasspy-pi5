#!/bin/bash

set -e

echo "Updating system..."
sudo apt update && sudo apt full-upgrade -y

echo "Installing dependencies..."
sudo apt install -y alsa-utils pulseaudio pulseaudio-utils curl pavucontrol

sudo groupadd -f docker
sudo usermod -aG audio $USER
sudo usermod -aG docker $USER

echo "Installing Docker..."
curl -sSL https://get.docker.com | sh

echo "Configuring PulseAudio for Docker use..."

# Enable UNIX socket for client access (if not already present)
mkdir -p ~/.config/pulse

cat > ~/.config/pulse/default.pa <<EOF
#!/usr/bin/pulseaudio -nF
.include /etc/pulse/default.pa
load-module module-native-protocol-unix
EOF

# Start pulseaudio manually
pulseaudio --start

# Confirm socket path
PULSE_SOCKET="/run/user/$(id -u)/pulse/native"
echo "PulseAudio socket should be at: $PULSE_SOCKET"

echo "Installing Bluetooth utilities..."
sudo apt install -y bluetooth bluez bluez-tools pulseaudio-module-bluetooth

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

