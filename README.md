# 🐧 Simple Arch Linux DWM Setup (Dotfiles)

A minimal, clean and fast **Arch Linux + DWM** setup.

---

## 📦 Requirements

Before using this setup, make sure you have:

- Arch Linux installed (**minimal install recommended via archinstall**)
- `yay` installed (AUR helper)[Optional]
- extra Repository must be enabled due to avoiding AUR!
- bibata-cursor-theme [If not wanna install using AUR. If you install yay then you can skip it.]
- Minimal Xorg setup (`xorg`, `xinit`)
- Required drivers installed manually:
  - GPU (Intel / AMD / NVIDIA)
  - Touchpad / mouse
  - Bluetooth (if needed)
  - Printer (if needed)

> ⚠️ Drivers are NOT included. Install them based on your hardware.

---

## 📁 Structure

```
.
├── .config/        → ~/.config/
├── Wallpaper/      → ~/
├── suckless/       → ~/.config/
├── .Xresources     → ~/
├── .bashrc         → ~/
├── .xinitrc        → ~/
├── pkglist.txt     → pacman packages
└── aurlist.txt     → yay packages
```

---

## ⚡ Installation

### 1. Clone the repo

```bash
git clone https://github.com/notmish/dwm.git
cd dwm
```

---

### 2. Copy files

```bash
cp -r .config/* ~/.config/
cp -r suckless ~/.config/
cp -r Wallpaper ~/
cp .Xresources ~/
cp .bashrc ~/
cp .xinitrc ~/
```

---

### 3. Install packages

```bash
sudo pacman -S --needed - < pkglist.txt
```
[Optional 👇 for Bibata-cursor-theme]
```
yay -S --needed - < aurlist.txt
```
[Must Avoid this command ☝️ above if you dont want AUR]


---

### 4. Build DWM and slstatus

```bash
cd ~/.config/suckless/dwm
sudo make clean install

cd ~/.config/suckless/slstatus
sudo make clean install
```

---

### 5. Apply settings and start

```bash
xrdb ~/.Xresources
startx
```

---

### I'm a startx guy so I use xinit. if you use things like SDDM or others make sure to copy the lines inside .xinitrc to your .xsession and .xprofile

## ⌨️ Keybindings

**Mod key = Super (Windows key)**

### Launch & Basics

| Key | Action |
|-----|--------|
| `Mod + Enter` | Open terminal (kitty) |
| `Mod + Space` | Open dmenu |
| `Mod + b` | Toggle bar |
| `Mod + q` | Close window |
| `Mod + Shift + q` | Quit DWM |

---

### Window Control

| Key | Action |
|-----|--------|
| `Mod + Left / Right` | Focus window |
| `Mod + Shift + Enter` | Swap with master |
| `Mod + Tab` | Switch to last tag |
| `Mod + Shift + Space` | Toggle floating |

---

### Layout & Size

| Key | Action |
|-----|--------|
| `Mod + Up / Down` | Resize master area |
| Layouts | `Tile`, `Floating`, `Monocle` |

---

### Tags (Workspaces)

| Key | Action |
|-----|--------|
| `Mod + 1-6` | Switch tag |
| `Mod + Shift + 1-6` | Move window to tag |
| `Mod + Ctrl + 1-6` | Toggle view |
| `Mod + Ctrl + Shift + 1-6` | Toggle tag |

---

### Brightness

| Key | Action |
|-----|--------|
| `Mod + Alt + Up` | Increase brightness |
| `Mod + Alt + Down` | Decrease brightness |

---

### Volume

| Key | Action |
|-----|--------|
| `Mod + Alt + Right` | Volume up |
| `Mod + Alt + Left` | Volume down |

---

### Screenshot


| Key | Action |
|-----|--------|
| `Mod + Print` | Fullscreen screenshot |
| `Mod + Shift + Print` | Selective area screenshot |

---

## 📝 Notes

- Check configs in `~/.config` if something breaks  
- Rebuild DWM after config changes:
  ```bash
  sudo make clean install
  ```
- This is a minimal setup → customize as needed  

---


## Mouse Cursor Theme (If you din't installed yay)

- cd into the ~/Downloads folder
  ```bash
  cd ~/Downloads
  ```
- copy the latest Bibata_Cursor
  ```bash
  curl -LO https://github.com/ful1e5/Bibata_Cursor/releases/latest/download/Bibata-Modern-Ice.tar.xz
  ```
- create the icons folder
  ```bash
  mkdir -p ~/.local/share/icons
  ```
- ectract them to their intended icons folders
  ```bash
  tar -xvf Bibata-Modern-Ice.tar.xz -C ~/.local/share/icons/
  ```
  ```bash
  sudo tar -xvf Bibata-Modern-Ice.tar.xz -C /usr/share/icons/
  ```
- reboot the system
  ```bash
  reboot
  ```
---

## ⭐ Credits

- https://suckless.org/
