#!/bin/bash

# Clone the GitHub repository
repo_url="https://github.com/epk/SF-Mono-Nerd-Font.git"
repo_name="SF-Mono-Nerd-Font"
clone_command="git clone $repo_url $repo_name"

if [ ! -d "$repo_name" ]; then
    echo "Cloning GitHub repository..."
    if ! $clone_command; then
        echo "Error cloning the GitHub repository."
        exit 1
    fi
else
    echo "GitHub repository already cloned."
fi

# Set the source directory where the OTF fonts are located (repository folder)
source_dir="$PWD/$repo_name"

# Set the destination directory where you want to install the fonts
dest_dir="/usr/share/fonts/OTF"

# Function to check if a font is already installed
is_font_installed() {
    fc-list | grep -q "$1"
}

# Check if fonts are already installed
otf_files=("$source_dir"/*.otf)
already_installed=()

for otf_file in "${otf_files[@]}"; do
    font_name=$(basename "$otf_file")
    if is_font_installed "$font_name"; then
        already_installed+=("$font_name")
    fi
done

if [ ${#already_installed[@]} -eq 0 ]; then
    echo "No fonts from the repository are already installed."
else
    echo "The following fonts are already installed:"
    for font in "${already_installed[@]}"; do
        echo "$font"
    done
    echo "No action required. Exiting."
    exit 0
fi

# Ensure the destination directory exists (create it if it doesn't)
sudo mkdir -p "$dest_dir"

# Copy OTF fonts to the destination directory with status messages
for otf_file in "${otf_files[@]}"; do
    font_name=$(basename "$otf_file")
    sudo cp "$otf_file" "$dest_dir"
    echo "Copying... ⏳ $font_name"
    echo "Successfully installed ✅ $font_name"
done

# Update the font cache
echo "Updating the font cache..."
sudo fc-cache -f -v
echo "Font cache has been updated."

# Clean up: remove the cloned repository folder
echo "Removing cloned repository folder..."
rm -rf "$source_dir"

echo "Installation completed."
