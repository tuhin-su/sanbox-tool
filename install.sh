#!/bin/bash

# Sanbox Installer Script

# Detect if running as root
if [ "$(id -u)" -eq 0 ]; then
    INSTALL_DIR="/usr/local/bin"
    echo "Running as root. Installing to $INSTALL_DIR"
else
    INSTALL_DIR="$HOME/.local/bin"
    echo "Running as user. Installing to $INSTALL_DIR"
fi

# Ensure the source file exists
if [ ! -f "sanbox" ]; then
    echo "Error: 'sanbox' file not found in the current directory."
    exit 1
fi

# Create directory if it doesn't exist
if [ ! -d "$INSTALL_DIR" ]; then
    echo "Creating directory $INSTALL_DIR..."
    mkdir -p "$INSTALL_DIR"
fi

# Install the file
echo "Installing sanbox to $INSTALL_DIR/sanbox..."
cp "sanbox" "$INSTALL_DIR/sanbox"

if [ $? -ne 0 ]; then
    echo "Error: Failed to copy file. If installing to a system directory, make sure you run with sudo."
    exit 1
fi

# Make it executable
chmod +x "$INSTALL_DIR/sanbox"
rm -rf ../sanbox-tool
echo "Installation complete!"
echo "Please ensure $INSTALL_DIR is in your PATH."
