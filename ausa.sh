#!/bin/bash

# Set exact Flutter path
export PATH="/home/prarlabs/flutter/bin:$PATH"

# Configuration
REPO_PATH="/home/prarlabs/Desktop/ausa_device_v2"
GITHUB_BRANCH="main"
BINARY_PATH="build/linux/arm64/release/bundle/ausa"

# Function to check if command exists
check_command() {
    if ! command -v $1 &> /dev/null; then
        echo "Error: $1 is not installed"
        exit 1
    fi
}

# Check required commands
echo "Checking required commands..."
check_command git
check_command flutter

# Navigate to project directory
echo "Navigating to project directory..."
cd $REPO_PATH || {
    echo "Error: Could not navigate to project directory"
    exit 1
}

# Pull latest code from GitHub
echo "Pulling latest code from GitHub..."
git pull origin $GITHUB_BRANCH || {
    echo "Error: Failed to pull from GitHub"
    exit 1
}

# Clean and get Flutter dependencies
echo "Getting Flutter dependencies..."
flutter clean
flutter pub get || {
    echo "Error: Failed to get Flutter dependencies"
    exit 1
}

# Build Linux app
echo "Building Flutter Linux app..."
flutter build linux --release || {
    echo "Error: Failed to build Linux app"
    exit 1
}

# Run the app in fullscreen
echo "Launching app in fullscreen..."
./$BINARY_PATH --start-fullscreen || {
    echo "Error: Failed to launch the app"
    exit 1
}