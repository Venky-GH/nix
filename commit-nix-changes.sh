#!/bin/bash

# Check if a commit message is provided
if [ -z "$1" ]; then
    echo "Usage: $0 \"commit message\""
    exit 1
fi

# Copy files
cp -rf ~/.config/nix/. .

# Show changes
git diff

# Add all changes
git add .

# Commit with provided message
git commit -m "$1"

# Push changes
git push
