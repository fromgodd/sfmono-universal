#!/bin/bash

# Check if script is run with sudo
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo:"
    echo "sudo $0"
    exit
fi

# Define variables
font_repo="https://github.com/shaunsingh/SFMono-Nerd-Font-Ligaturized.git"
font_destination="$HOME/.local/share/fonts/"

# Clone font repository
git clone "$font_repo" || { echo "Failed to clone font repository."; exit 1; }

# Navigate to font folder
cd SFMono-Nerd-Font-Ligaturized || { echo "Failed to change directory to font folder."; exit 1; }

# Check if destination folder exists, create it if not
if [ ! -d "$font_destination" ]; then
    mkdir -p "$font_destination" || { echo "Failed to create font destination folder."; exit 1; }
fi

# Copy font files to destination folder
cp *.otf "$font_destination" || { echo "Failed to copy font files."; exit 1; }

echo "Fonts copied successfully."
