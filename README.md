# Ubuntu i3 Desktop Install Script

This repository contains an automated installation script (`install.sh`) that transforms a stock **Ubuntu Server** install into a **high-performance i3-based development workstation**.

The script is designed to be **safe, repeatable, and interactive**, featuring automated GPU driver detection to ensure smooth hardware-accelerated video playback and UI rendering.

If you are getting permission errors when trying to execute this install script, be sure to add proper permissions with the following command:

- `chmod +x install.sh`

---

## Features Overview

- Optional **Wi-Fi setup** via CLI before installation
- **Xorg Display Server** and automatic **GPU Driver detection** (Nvidia/AMD/Intel)
- Full **i3 window manager** environment
- **Polybar** status bar with **Nerd Font** icons
- **Alacritty** GPU-accelerated terminal
- **Picom** compositor (configured for VS-Sync/Performance)
- **Thunar** file manager
- Development environments for **Rust** and **Python**
- **Fresh** Text Editor for sane text editing on Linux
- Audio via **PipeWire**
- Automatic configuration deployment with timestamped backups

---

## Wi-Fi Setup (Optional)

At the start of the script, available Wi-Fi networks are scanned using `nmcli`.

You are prompted to:
- View available SSIDs
- Choose whether to connect
- Enter an SSID and password (or connect to an open network)

This allows the system to be online **before any packages are installed**.

---

## System Update & Graphics Stack

The script performs a full system update and configures the display layer:

1. **Update**: `apt update && apt upgrade`
2. **Xorg**: Installs the core X11 display server.
3. **Drivers**: 
   - **Nvidia**: Automatically detects hardware and installs proprietary drivers via the Graphics PPA.
   - **AMD/Intel**: Installs Mesa and VA-API drivers for hardware video acceleration (prevents YouTube lag).



---

## Desktop Environment Components

The following core desktop components are installed:

- **i3** – Window manager
- **Polybar** – Status bar
- **Alacritty** – GPU-accelerated terminal
- **i3lock** – Screen locker
- **Picom** – Compositor (transparency, vsync, and glx backend)
- **Feh** – Wallpaper manager
- **LXAppearance** – GTK theme configuration
- **LightDM** – Display manager (Login Screen)

---

## File Management

- **Thunar** file manager
- Thunar archive plugin
- File Roller
- GVFS backends and FUSE support

This provides full removable-media and network filesystem integration.

---

## Fonts

To ensure your terminal and status bars render correctly, the script installs:

- **JetBrainsMono Nerd Font**: Essential for the icons used in Polybar and modern terminal themes.
- **Google Core Fonts**: `fonts-croscore` and `fonts-crosextra-caladea`.

---

## Web & Media Applications

Installed applications include:

- **Firefox** (Snap)
- **Chromium** (Snap)
- **OBS Studio**
- **Audacity**
- **Kdenlive**
- **LibreOffice**
- **VLC**

---

## Development Toolchains

### Rust
Installs the full Rust development stack:
- `rustc`, `cargo`, and `rust-analyzer`.

### Python
Installs a complete Python development environment:
- Python 3, `pip`, `venv`, and `Pyright` (LSP).

### IDEs & Editors
- **CLion** & **PyCharm Community Edition** (via Snap classic).
- **Fresh Text Editor** (Installed by default).

---

## Utilities

- **rofi** (App launcher)
- **fzf** (Fuzzy finder)
- **xclip** & **xdotool** (Clipboard and input automation)
- **brightnessctl** & **flameshot** (Screen brightness and screenshots)
- **breeze-icon-theme**

---

## Audio System

Configures modern Linux audio using **PipeWire**:
- `pipewire`, `wireplumber`, `pipewire-pulse`, `pipewire-alsa`, `pipewire-jack`.

The user-level WirePlumber service is enabled automatically to manage audio routing.

---

## Configuration Deployment

The script creates required configuration directories and uses a `backup_and_cp` function to deploy:
- **i3 config**
- **Alacritty settings**
- **Picom (Compositor) rules**
- **Polybar themes and launch scripts**

Existing configs are backed up with a `.bak.[TIMESTAMP]` extension to prevent data loss.

---

## i3 Autostart Notes (IMPORTANT)

After installation, ensure the following lines exist in your i3 config to initialize your environment correctly:

```text
# Graphics & UI
exec --no-startup-id picom --config ~/.config/picom/picom.conf
exec --no-startup-id feh --bg-scale /path/to/your/wallpaper.jpg

# Network & System
exec --no-startup-id nm-applet
exec --no-startup-id ~/.config/polybar/launch.sh