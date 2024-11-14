# Ausa Device v2 - Raspberry Pi 5 Setup Guide

This guide provides instructions for setting up and running the Ausa Device application on a Raspberry Pi 5.

## Prerequisites

Before starting, ensure you have:
- Raspberry Pi 5
- Display connected via HDMI
- Internet connection
- SSH access (recommended for remote setup)

## Initial Setup

Update system and install required dependencies:

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install dependencies
sudo apt install -y git clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev libstdc++-12-dev
sudo apt install -y libunwind-dev libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
```

## Flutter Installation

Install Flutter on the Raspberry Pi:

```bash
# Clone Flutter
cd ~
git clone https://github.com/flutter/flutter.git

# Add Flutter to PATH
echo 'export PATH="$PATH:$HOME/flutter/bin"' >> ~/.bashrc
source ~/.bashrc

# Set up Flutter
flutter doctor
flutter config --enable-linux-desktop
```

## Application Setup

Clone and build the application:

```bash
# Clone repository
git clone https://github.com/AusaHealth/ausa_device_v2.git
cd ausa_device_v2

# Get dependencies and build
flutter pub get
flutter build linux
```

## Running the Application

### Manual Run

```bash
cd build/linux/x64/release/bundle
./ausa_device_v2
```

### Automatic Startup (System Service)

Create a systemd service:

```bash
sudo nano /etc/systemd/system/ausa-device.service
```

Add the following content:

```ini
[Unit]
Description=Ausa Device Application
After=network.target

[Service]
ExecStart=/home/pi/ausa_device_v2/build/linux/x64/release/bundle/ausa_device_v2
WorkingDirectory=/home/pi/ausa_device_v2/build/linux/x64/release/bundle
User=pi
Restart=always

[Install]
WantedBy=multi-user.target
```

Enable and start the service:

```bash
sudo systemctl enable ausa-device
sudo systemctl start ausa-device
```

### Autostart in Desktop Environment

Create an autostart entry:

```bash
mkdir -p ~/.config/autostart
nano ~/.config/autostart/ausa-device.desktop
```

Add the following content:

```desktop
[Desktop Entry]
Type=Application
Name=Ausa Device
Exec=/home/pi/ausa_device_v2/build/linux/x64/release/bundle/ausa_device_v2
Path=/home/pi/ausa_device_v2/build/linux/x64/release/bundle
Terminal=false
X-GNOME-Autostart-enabled=true
```

## Update Script

Create an update script for easy maintenance:

```bash
nano ~/update-ausa.sh
```

Add the following content:

```bash
#!/bin/bash

cd ~/ausa_device_v2
git pull
flutter clean
flutter pub get
flutter build linux
sudo systemctl restart ausa-device
```

Make it executable:

```bash
chmod +x ~/update-ausa.sh
```

## Display Configuration

Create a display configuration file:

```bash
sudo nano /etc/X11/xorg.conf.d/99-ausa-display.conf
```

Add the following content:

```
Section "Monitor"
    Identifier "HDMI-1"
    Option "PreferredMode" "1920x1080"
    Option "Primary" "true"
EndSection

Section "Screen"
    Identifier "Screen0"
    Monitor "HDMI-1"
    DefaultDepth 24
    SubSection "Display"
        Depth 24
        Modes "1920x1080"
    EndSubSection
EndSection
```

## Kiosk Mode Setup

Create a kiosk mode script:

```bash
nano ~/start-kiosk.sh
```

Add the following content:

```bash
#!/bin/bash
xset s off
xset -dpms
xset s noblank
~/ausa_device_v2/build/linux/x64/release/bundle/ausa_device_v2
```

Make it executable:

```bash
chmod +x ~/start-kiosk.sh
```

## Monitoring and Maintenance

### Check Application Status
```bash
systemctl status ausa-device
```

### View Logs
```bash
journalctl -u ausa-device -f
```

### Debug Mode
```bash
cd ~/ausa_device_v2
flutter run -d linux
```

## Automatic Updates

To set up automatic daily updates, add a cron job:

```bash
crontab -e
```

Add the following line for updates at 3 AM:

```
0 3 * * * /home/pi/update-ausa.sh
```

## Troubleshooting

If the application fails to start:

1. Check system logs:
```bash
journalctl -xe
```

2. Verify Flutter installation:
```bash
flutter doctor
```

3. Check application permissions:
```bash
ls -l ~/ausa_device_v2/build/linux/x64/release/bundle/ausa_device_v2
```

4. Verify display settings:
```bash
xrandr --query
```

## Support

For issues and support, please create an issue in the GitHub repository.