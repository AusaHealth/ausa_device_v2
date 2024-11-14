#!/bin/bash

# Go to project directory
cd /home/prarlabs/Desktop/ausa_device_test

# Build and launch
flutter build linux --release
./build/linux/arm64/release/bundle/ausa --start-fullscreen