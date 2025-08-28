#!/bin/bash

set -e

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="darwin"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    OS="linux"
else
    echo "Unsupported OS: $OSTYPE"
    exit 1
fi

# Download and install chezmoi
echo "Installing chezmoi for $OS..."
sh -c "$(curl -fsLS get.chezmoi.io)" -- -b ~/.local/bin

# Add to PATH if not already there
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$HOME/.local/bin:$PATH"
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

# Prompt for GitHub token
echo -n "Enter your GitHub token: "
read -s GITHUB_TOKEN < /dev/tty
echo

# Debug: Check if token was read (show first 4 chars only)
echo "Token starts with: ${GITHUB_TOKEN:0:4}..."

# Initialize chezmoi with your repo
~/.local/bin/chezmoi init --apply https://damonLL:$GITHUB_TOKEN@github.com/damonLL/dot-files.git

echo "chezmoi installed and initialized successfully!"
