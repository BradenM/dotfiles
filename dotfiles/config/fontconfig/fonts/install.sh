#!/usr/bin/env bash

# Load Scripts
source "/home/${SUDO_USER}/.scripts/git.sh"

# Nerd Fonts to Install
FONTS=("FiraCode")

# Fetch
mkdir /tmp/install_fonts
for font in "${FONTS[$@]}"; do
    dest="/tmp/install_fonts/${font}"
    src="patched-fonts/${font}"
    git_dir "ryanoasis/nerd-fonts" "$src" "$dest"
done

pushd /tmp/install_fonts

# Install
echo Installing fonts...
find . -iname "*.otf" -not -iname "*Windows Compatible.otf" -print0 -execdir install -Dm644 {} "$pkgdir/usr/share/fonts/OTF/{}" \;
find . -iname "*.ttf" -not -iname "*Windows Compatible.ttf" -print0 -execdir install -Dm644 {} "$pkgdir/usr/share/fonts/TTF/{}" \;

popd

# Cleanup
rm -rf /tmp/install_fonts

echo Done!
