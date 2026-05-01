#!/usr/bin/env bash

set -euo pipefail

########################################
# Safety: exit on error anywhere
########################################
trap 'echo "❌ Error occurred. Exiting..."; exit 1' ERR

########################################
# Helper functions
########################################
log() {
    echo -e "\n[INFO] $1"
}

ask() {
    read -rp "$1 (y/n): " choice
    [[ "$choice" =~ ^[Yy]$ ]]
}

########################################
# Keep sudo alive
########################################
sudo -v
while true; do sudo -n true; sleep 60; done 2>/dev/null &
SUDO_KEEPALIVE_PID=$!

cleanup() {
    kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
}
trap cleanup EXIT

########################################
# Start
########################################
clear
log "Starting Arch dotfiles setup..."

########################################
# Post-install check
########################################
log "Before continuing, ensure you have:"
echo "- Installed Arch base system"
echo "- Installed GPU / drivers / touchpad / wifi etc."
echo "- Installed xorg + xinit (if using startx)"
echo ""

if ! ask "Have you completed post-install setup (drivers, xorg, etc.)?"; then
    echo "❌ Please complete post-install setup first."
    exit 0
fi

########################################
# yay check
########################################
if command -v yay >/dev/null 2>&1; then
    log "yay is already installed."
else
    log "yay not found."

    if ask "Do you want to install yay?"; then
        log "Installing yay..."

        TEMP_DIR="/tmp/yay-build"
        rm -rf "$TEMP_DIR"

        sudo pacman -S --noconfirm base-devel git
        git clone https://aur.archlinux.org/yay.git "$TEMP_DIR"
        cd "$TEMP_DIR"
        makepkg -si --noconfirm

        cd -
        rm -rf "$TEMP_DIR"

        log "yay installed and temporary files cleaned."
    else
        echo "❌ yay is required. Exiting."
        exit 1
    fi
fi

########################################
# Copy dotfiles
########################################
log "Copying dotfiles to home directory..."

cp -rv .config/* "$HOME/.config/"
cp -rv suckless "$HOME/.config/"
cp -rv Wallpaper "$HOME/"
cp -v .Xresources "$HOME/"
cp -v .bashrc "$HOME/"
cp -v .xinitrc "$HOME/"

log "Dotfiles copied successfully."

########################################
# Install packages
########################################
log "Installing pacman packages..."
sudo pacman -S --needed - < pkglist.txt

log "Installing AUR packages..."
yay -S --needed - < aurlist.txt

########################################
# Build suckless programs
########################################
log "Building DWM..."
cd "$HOME/.config/suckless/dwm"
sudo make clean install

log "Building slstatus..."
cd "$HOME/.config/suckless/slstatus"
sudo make clean install

cd "$HOME"

########################################
# Session setup choice
########################################
log "Session setup selection"

if ask "Do you want to use SDDM instead of startx?"; then
    log "Configuring SDDM (.xprofile setup)..."

    cp -v "$HOME/.xinitrc" "$HOME/.xprofile"

    log ".xinitrc copied to .xprofile for SDDM compatibility."
else
    log "Using startx (.xinitrc setup)..."
fi

########################################
# Final steps
########################################
log "Applying X resources..."
xrdb "$HOME/.Xresources" || true

log "Setup complete!"
echo ""
echo "✅ You can now start DWM using:"
echo "   startx"
echo ""
echo "Enjoy your setup."
