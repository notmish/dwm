#!/usr/bin/env bash
#
# Arch Linux dwm setup (official repositories only, no AUR).
# Run as a regular user:  bash auto-install.sh
#
set -euo pipefail

REPO_URL="https://github.com/notmish/dwm.git"
CURSOR_URL="https://github.com/ful1e5/Bibata_Cursor/releases/latest/download/Bibata-Modern-Ice.tar.xz"

PACKAGES=(
    # toolchain and libraries needed to build dwm / slstatus
    base-devel git curl libx11 libxinerama libxft
    # X11 session
    xorg-server xorg-xinit xorg-xrandr xorg-xrdb
    # desktop
    dmenu kitty picom dunst libnotify xwallpaper maim xclip brightnessctl
    # audio (volume keys use wpctl)
    pipewire pipewire-alsa pipewire-pulse wireplumber
    # file manager and archive support
    thunar thunar-archive-plugin file-roller gvfs tumbler ffmpegthumbnailer
    udisks2 xdg-user-dirs 7zip unrar unzip
    # appearance
    materia-gtk-theme papirus-icon-theme lxappearance
    ttf-jetbrains-mono ttf-jetbrains-mono-nerd
    # command-line tools
    btop fastfetch lsd vim cmatrix
)

log() { printf '\n\033[1;34m==>\033[0m %s\n' "$*"; }
die() { printf '\033[1;31merror:\033[0m %s\n' "$*" >&2; exit 1; }
trap 'die "failed at line $LINENO - fix the problem and re-run (the script is safe to repeat)"' ERR

[[ $EUID -ne 0 ]] || die "run as a regular user, not root (sudo is used where needed)"
command -v pacman >/dev/null || die "pacman not found - this script is for Arch Linux"

log "Requesting sudo access"
sudo -v

log "Installing packages"
sudo pacman -Syu --needed --noconfirm "${PACKAGES[@]}"

# Use the repo next to this script; if it is not there, clone it.
SRC="$(cd -- "$(dirname -- "${BASH_SOURCE[0]:-.}")" && pwd)"
if [[ ! -d $SRC/suckless ]]; then
    log "Cloning $REPO_URL"
    SRC="$(mktemp -d)"
    trap 'rm -rf "$SRC"' EXIT
    git clone --depth 1 "$REPO_URL" "$SRC"
fi

log "Installing configuration files (replaced files are backed up, not lost)"
cp -rT --backup=numbered "$SRC/.config" "$HOME/.config"
cp --backup=numbered -t "$HOME" "$SRC/.bashrc" "$SRC/.xinitrc" "$SRC/.Xresources"
cp -rT "$SRC/Wallpaper" "$HOME/Wallpaper"
[[ ! -e $HOME/.config/suckless ]] || mv "$HOME/.config/suckless" "$HOME/.config/suckless.bak.$(date +%s)"
cp -r "$SRC/suckless" "$HOME/.config/suckless"

log "Installing Bibata-Modern-Ice cursor theme"
mkdir -p "$HOME/.local/share/icons"
curl -fsSL "$CURSOR_URL" | tar -xJ -C "$HOME/.local/share/icons"

for prog in dwm slstatus; do
    log "Building and installing $prog"
    make -C "$HOME/.config/suckless/$prog" clean all
    sudo make -C "$HOME/.config/suckless/$prog" install
done

log "Finishing up"
xdg-user-dirs-update
sudo usermod -aG video "$(id -un)"

log "Done. Reboot, log in on a TTY and run: startx"
