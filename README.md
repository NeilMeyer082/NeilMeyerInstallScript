# Ubuntu i3 Desktop Install Script

This repository contains an automated installation script (`install.sh`) that sets up a **fully-featured i3-based desktop environment** on Ubuntu, including development tools, multimedia software, and a curated window-manager workflow.

The script is designed to be **safe, repeatable, and interactive**, with backups for existing configuration files.

If you are getting permission erros when trying to execute this install script, be sure to add proper permissions with the following command.

- `chmod +x install.sh`


---

## Features Overview

- Optional **Wi-Fi setup** via CLI before installation
- Full **i3 window manager** environment
- **Polybar** status bar
- **Alacritty** terminal
- **Picom** compositor
- **Thunar** file manager
- Development environments for **Rust** and **Python**
- **Fresh** Text Editor for sane text editing on Linux
- Audio via **PipeWire**
- Automatic configuration deployment with backups
- Designed for laptop and desktop usage

---

## Wi-Fi Setup (Optional)

At the start of the script, available Wi-Fi networks are scanned using `nmcli`.

You are prompted to:
- View available SSIDs
- Choose whether to connect
- Enter an SSID and password (or connect to an open network)

This allows the system to be online **before any packages are installed**.

---

## System Update

The script performs a full system update:

- `apt update`
- `apt upgrade`

This ensures all packages install against the latest available dependencies.

---

## Desktop Environment Components

The following core desktop components are installed:

- **i3** – Window manager
- **Polybar** – Status bar
- **Alacritty** – GPU-accelerated terminal
- **i3lock** – Screen locker
- **Picom** – Compositor (transparency, vsync)
- **Feh** – Wallpaper manager
- **LXAppearance** – GTK theme configuration
- **LightDM** – Display manager

---

## File Management

- **Thunar** file manager
- Thunar archive plugin
- File Roller
- GVFS backends and FUSE support

This provides full removable-media and network filesystem integration.

---

## Fonts

Installs Google Core Fonts, including **Cousine**, suitable for terminals and code editors:

- `fonts-croscore`
- `fonts-crosextra-cousine`

---

## Web & Media Applications

Installed applications include:

- Firefox (Snap)
- Chromium (Snap)
- OBS Studio
- Audacity
- Kdenlive
- LibreOffice
- VLC

---

## Development Toolchains

### Rust

Installs the full Rust development stack:

- `rustc`
- `cargo`
- `rust-analyzer`

### Python

Installs a complete Python development environment:

- Python 3
- pip
- venv
- Pyright (LSP)

---

## IDEs

Installed via Snap (classic confinement):

- **CLion**
- **PyCharm Community Edition**

---

## Fresh Text Editor

- Fresh Text Editor Installed by default

---

## Utilities

Additional productivity and i3-related tools:

- rofi
- fzf
- xdotool
- xclip
- xdg-utils
- python3-i3ipc
- brightnessctl
- flameshot
- breeze-icon-theme

---

## Audio System

Configures modern Linux audio using PipeWire:

- pipewire
- wireplumber
- pipewire-pulse
- pipewire-alsa
- pipewire-jack

The user-level WirePlumber service is enabled automatically.

---

## Network Management

- Installs `network-manager-gnome`
- Provides `nm-applet` for tray/network control
- Compatible with Polybar and i3 workflows

---

## Configuration Deployment

The script:

- Creates required configuration directories
- Backs up existing configs with timestamps
- Copies repo-provided configs for:
  - i3
  - Alacritty
  - Picom
  - Polybar
  - Fresh

---

## Custom Scripts & Assets

- Installs a fuzzy file search script to `~/.local/bin`
- Deploys a left-handed cursor theme if present
- Reload i3 with `$mod + Shift + r` command


---

## i3 Autostart Notes (IMPORTANT)

After installation, ensure the following lines exist in your i3 config:

```text
exec --no-startup-id picom --config ~/.config/picom/picom.conf
exec --no-startup-id feh --bg-scale /path/to/your/wallpaper.jpg
exec --no-startup-id nm-applet
exec --no-startup-id polybar main

