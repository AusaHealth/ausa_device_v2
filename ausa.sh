

# variables
BINARY_PATH="build/linux/arm64/release/bundle/ausa"
REPO_PATH="/home/prarlabs/Desktop/ausa_device_test"
GITHUB_BRANCH="main"
# variables


check_command() {
    if ! command -v $1 &> /dev/null; then
        echo "Error: $1 is not installed"
        exit 1
    fi
}

check_command git
check_command flutter


cd $REPO_PATH || {
    echo "Error: Could not navigate to project directory"
    exit 1
}


echo "Pulling latest code from GitHub..."
git pull origin $GITHUB_BRANCH || {
    echo "Error: Failed to pull from GitHub"
    exit 1
}


echo "Getting Flutter dependencies..."
flutter clean
flutter pub get || {
    echo "Error: Failed to get Flutter dependencies"
    exit 1
}


echo "Building Flutter Linux app..."
flutter build linux --release || {
    echo "Error: Failed to build Linux app"
    exit 1
}


echo "Launching app in fullscreen..."
$BINARY_PATH --start-fullscreen || {
    echo "Error: Failed to launch the app"
    exit 1
}