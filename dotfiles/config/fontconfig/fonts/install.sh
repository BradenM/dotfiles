#!/usr/bin/env bash

# Load Scripts
source "/home/${SUDO_USER}/.scripts/git.sh"

# File location dir and Patch script path
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
PATCH_SCRIPT="$DIR/patch.py"

# Nerd Fonts to Install
FONTS=("FiraCode" "Overpass")

# Local Fonts to Patch and Install
FONTS_LOCAL=("SFPro")

# Setup Patcher
echo Downloading Font Patcher...
mkdir -p /tmp/install_fonts/src
mkdir /tmp/install_fonts/fonts
pushd /tmp/install_fonts

git_dir "ryanoasis/nerd-fonts" "/src/svgs" "./src/svgs"
git_dir "ryanoasis/nerd-fonts" "/src/glyphs" "./src/glyphs"
curl -LO "https://raw.githubusercontent.com/ryanoasis/nerd-fonts/master/font-patcher"

# Fetch
echo Fetching Fonts...
for font in "${FONTS[@]}"; do
    echo "Retrieving: ${font}"
    dest="/tmp/install_fonts/fonts/${font}"
    src="src/unpatched-fonts/${font}"
    git_dir "ryanoasis/nerd-fonts" "$src" "$dest"
done

# Copy Local
echo Adding Local Fonts...
for font in "${FONTS_LOCAL[@]}"; do
    echo "Copying: ${font}"
    dest="/tmp/install_fonts/fonts/${font}"
    src="$DIR/${font}"
    cp -r "$src" "$dest"
done

# Report
echo
echo "Fonts to Install:"
tree -L 2 "/tmp/install_fonts/fonts/"
sleep 5

# Patch
echo Patching Fonts...
python "$PATCH_SCRIPT"

# Install
echo Installing fonts...

find ./patched -iname "*.otf" -not -iname "*Windows Compatible.otf" -print -execdir install -Dm644 {} "/usr/share/fonts/OTF/{}" \;
find ./patched -iname "*.ttf" -not -iname "*Windows Compatible.ttf" -print -execdir install -Dm644 {} "/usr/share/fonts/TTF/{}" \;

popd

# Cleanup
rm -rf /tmp/install_fonts

echo Done!
