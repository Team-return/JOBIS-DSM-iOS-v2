#!/bin/bash

# Exit on error
set -e

# Enable debug output
set -x

# Store the original project directory
PROJECT_DIR="$(pwd)"
echo "Project directory: $PROJECT_DIR"
echo "Directory contents:"
ls -la

# Move to parent directory
cd ..

# Clone XCConfig repository
echo "Cloning JOBIS-v2-XCConfig..."
if [ -d "JOBIS-v2-XCConfig" ]; then
    echo "JOBIS-v2-XCConfig already exists, removing..."
    rm -rf JOBIS-v2-XCConfig
fi
git clone https://github.com/Team-return/JOBIS-v2-XCConfig.git
echo "Moving XCConfig to project root..."
cp -R JOBIS-v2-XCConfig/XCConfig/ "$PROJECT_DIR/"
rm -rf JOBIS-v2-XCConfig

# Clone GoogleInfo repository
echo "Cloning JOBIS-GoogleInfo..."
if [ -d "JOBIS-GoogleInfo" ]; then
    echo "JOBIS-GoogleInfo already exists, removing..."
    rm -rf JOBIS-GoogleInfo
fi
git clone https://github.com/Team-return/JOBIS-GoogleInfo.git
echo "Moving FireBase config to project..."
mkdir -p "$PROJECT_DIR/Projects/App/Resources"
cp -R JOBIS-GoogleInfo/FireBase/ "$PROJECT_DIR/Projects/App/Resources/"
rm -rf JOBIS-GoogleInfo

# Install make if not already installed
if ! command -v make &> /dev/null; then
    echo "Installing make..."
    brew install make
else
    echo "make is already installed"
fi

# Install tuist via Homebrew
echo "Installing tuist..."
if ! command -v tuist &> /dev/null; then
    echo "Tuist not found, installing via curl..."
    curl -Ls https://install.tuist.io | bash
    export PATH="$HOME/.tuist/bin:$PATH"
else
    echo "Tuist is already installed"
fi

# Verify tuist installation
echo "Tuist version:"
tuist version

# Install specific tuist version if needed
REQUIRED_VERSION="3.40.0"
CURRENT_VERSION=$(tuist version 2>&1 | grep -o '[0-9]*\.[0-9]*\.[0-9]*' | head -1)
echo "Current tuist version: $CURRENT_VERSION"
echo "Required tuist version: $REQUIRED_VERSION"

if [ "$CURRENT_VERSION" != "$REQUIRED_VERSION" ]; then
    echo "Installing tuist $REQUIRED_VERSION..."
    tuist install $REQUIRED_VERSION
    export PATH="$HOME/.tuist/bin:$PATH"
fi

# Navigate back to project directory
echo "Returning to project directory: $PROJECT_DIR"
cd "$PROJECT_DIR"

# Reset project
echo "Running make reset..."
make reset

# Fetch dependencies
echo "Fetching tuist dependencies..."
tuist fetch

# Generate project
echo "Generating Xcode project..."
TUIST_CI=1 tuist generate

echo "ci_post_clone.sh completed successfully!"
