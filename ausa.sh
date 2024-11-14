#!/bin/bash

# Variables
BINARY_PATH="build/linux/arm64/release/bundle/ausa"
REPO_PATH="/home/prarlabs/Desktop/ausa_device_test"
GITHUB_BRANCH="main"
LOG_FILE="/tmp/flutter_deploy.log"

# Function to log messages
log_message() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "[$timestamp] $1" | tee -a "$LOG_FILE"
}

# Function to check commands with detailed output
check_command() {
    if ! command -v "$1" &> /dev/null; then
        log_message "Error: $1 is not installed"
        log_message "PATH is: $PATH"
        exit 1
    else
        log_message "✓ Found $1 at: $(which $1)"
    fi
}

# Clear previous log
> "$LOG_FILE"

# Check required commands
log_message "Checking required commands..."
check_command git
check_command flutter
check_command chmod

# Navigate to project directory
log_message "Navigating to project directory: $REPO_PATH"
cd "$REPO_PATH" || {
    log_message "Error: Could not navigate to project directory: $REPO_PATH"
    log_message "Current directory is: $(pwd)"
    exit 1
}

# Git operations
log_message "Checking git status..."
git status || {
    log_message "Error: Git repository check failed"
    exit 1
}

log_message "Pulling latest code from GitHub..."
git pull origin "$GITHUB_BRANCH" || {
    log_message "Error: Failed to pull from GitHub"
    log_message "Git remote: $(git remote -v)"
    exit 1
}

# Flutter operations
log_message "Checking Flutter version and channel..."
flutter --version | tee -a "$LOG_FILE"

log_message "Getting Flutter dependencies..."
flutter clean || log_message "Warning: Flutter clean failed, continuing..."
flutter pub get || {
    log_message "Error: Failed to get Flutter dependencies"
    log_message "Flutter doctor output:"
    flutter doctor -v | tee -a "$LOG_FILE"
    exit 1
}

# Build process
log_message "Building Flutter Linux app..."
flutter build linux --release || {
    log_message "Error: Failed to build Linux app"
    log_message "Checking build directory structure:"
    ls -la build/linux/arm64/release/ | tee -a "$LOG_FILE"
    exit 1
}

# Check if binary exists and is executable
if [ ! -f "$BINARY_PATH" ]; then
    log_message "Error: Binary not found at $BINARY_PATH"
    log_message "Contents of build directory:"
    ls -R build/linux/ | tee -a "$LOG_FILE"
    exit 1
fi

# Make binary executable
log_message "Making binary executable..."
chmod +x "$BINARY_PATH" || {
    log_message "Error: Failed to make binary executable"
    exit 1
}

# Launch application
log_message "Launching app in fullscreen..."
export DISPLAY=:0  # Ensure X display is set
"$BINARY_PATH" --start-fullscreen || {
    log_message "Error: Failed to launch the app"
    log_message "X11 display variable: $DISPLAY"
    log_message "Current user: $(whoami)"
    log_message "Check X11 permissions: $(xhost +)"
    exit 1
}

log_message "Deployment completed successfully"