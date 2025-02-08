#!/bin/bash

# Usage
# ~/Code/git-repositories/nix/commit-nix-changes.sh ""

# Exit if any command fails
set -e

# Define colors
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
RESET="\e[0m"

# Logging functions
log_info() { printf "${GREEN}[INFO] $1${RESET}"; }
log_warning() { printf "${YELLOW}[WARNING] $1${RESET}"; }
log_error() { printf "${RED}[ERROR] $1${RESET}"; }

# Check if a commit message is provided
if [ -z "$1" ]; then
    log_error "Usage: $0 \"commit message\"\n"
    exit 1
fi

TARGET_DIR=~/Code/git-repositories/nix

# Ensure the target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    log_error "Target directory '$TARGET_DIR' does not exist.❌\n"
    exit 1
fi

# Ensure the target directory is a Git repository
if [ ! -d "$TARGET_DIR/.git" ]; then
    log_error "'$TARGET_DIR' is not a Git repository.❌\n"
    exit 1
fi

# Copy files
log_info "Copying Nix configuration files from '~/.config/nix' to '$TARGET_DIR'...\n"
cp -rf ~/.config/nix/. "$TARGET_DIR"

# List files affected
log_info "Files affected:"
git -C "$TARGET_DIR" status

# Show changes
log_info "Refer to the following diff:"
git -C "$TARGET_DIR" diff

# Ask for user confirmation
read -rp "Do you want to continue? (y/n): " choice
if [[ "$choice" != "y" && "$choice" != "Y" ]]; then
    log_warning "Operation aborted by user.\n"
    exit 1
fi

# Add all changes
log_info "Staging all changes...\n"
git -C "$TARGET_DIR" add .

# Commit with provided message
log_info "Committing changes...\n"
git -C "$TARGET_DIR" commit -m "$1"

# Push changes
log_info "Pushing changes to the remote repository...🚀\n"
git -C "$TARGET_DIR" push

log_info "Operation completed successfully!✅\n"
