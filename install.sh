#!/usr/bin/env bash
set -euo pipefail

# ----- Wi-Fi Setup -----
echo "Scanning for available Wi-Fi networks..."
nmcli device wifi rescan >/dev/null 2>&1
sleep 3
nmcli device wifi list

read -rp "Do you want to connect to a Wi-Fi network before continuing? [y/N]: " wifi_answer
wifi_answer=${wifi_answer,,}  # lowercase

if [[ "$wifi_answer" == "y" || "$wifi_answer" == "yes" ]]; then
    read -rp "Enter SSID to connect to: " wifi_ssid
    read -rsp "Enter password for '$wifi_ssid' (leave blank if open network): " wifi_pass
    echo

    if [[ -z "$wifi_pass" ]]; then
        echo "Connecting to open network '$wifi_ssid'..."
        nmcli device wifi connect "$wifi_ssid"
    else
        echo "Connecting to '$wifi_ssid'..."
        nmcli device wifi connect "$wifi_ssid" password "$wifi_pass"
    fi

    echo "Connection attempt finished. Checking status..."
    nmcli device status
    echo
else
    echo "Skipping Wi-Fi setup. Make sure you are connected manually."
fi

# ----- Timestamp for backups -----
TIMESTAMP=$(date +%Y%m%d-%H%M%S)

echo "Upgrading and updating Ubuntu..."
sudo apt update -y
sudo apt upgrade -y
clear
echo "Update and Upgrade Complete"

echo "Installing Software Properties Common"
sudo apt install software-properties-common -y 
clear
echo "Software-Properties-Common Installed"

echo "Installing i3"
sudo apt install i3 -y
clear
echo "i3 installed"

echo "Installing Polybar"
sudo apt install polybar -y
clear
echo "Polybar Installed"

echo "Installing Alacritty"
sudo apt install alacritty -y
clear
echo "Alacritty Installed"

echo "Installing i3Lock"
sudo apt install i3lock -y
clear
echo "I3Lock Installed"

echo "Installing Feh"
sudo apt install feh -y
clear
echo "Feh Installed"

echo "Installing Picom"
sudo apt install picom -y 
clear
echo "Picom Installed"

echo "Installing LXApperance"
sudo apt install lxappearance -y 
clear
echo "LXApperance installed"

echo "Install Git"
sudo apt install git -y 
clear
echo "Git Installed"

echo "Install CURL"
sudo apt install curl -y
clear
echo "Curl Installed"

echo "Installing Unzip"
sudo apt install unzip -y
clear
echo "Unzip Installed"

echo "Installing File Manager"
sudo apt install -y thunar thunar-archive-plugin file-roller gvfs-backends gvfs-fuse
clear
echo "File Manager Installed"

echo "Installing Fonts"
sudo apt install fonts-croscore fonts-crosextra-cousine -y
clear
echo "Fonts installed"

echo "Installing Firefox" 
sudo snap install firefox
clear 
echo "Firefox Installed"

echo "Installing Chromium"
sudo snap install chromium
clear
echo "Chromium Installed"

echo "Installing OBS"
sudo apt install obs-studio -y
clear
echo "OBS installed"

echo "Installing Audacity"
sudo apt install audacity -y
clear
echo "Audacity Installed"

echo "Installing Kdenlive"
sudo apt install kdenlive -y 
clear
echo "Kdenlive installed"

echo "Installing LibreOffice"
sudo apt install libreoffice -y 
clear
echo "LibreOffice installed."

echo "Installing VLC"
sudo apt install vlc -y
clear
echo "VLC installed."

echo "Installing Rust toolchain"
sudo apt install -y rustc cargo rust-analyzer
clear
echo "Rust Installed"

echo "Installing Python development environment"
sudo apt install -y python3 python3-pip python3-venv pyright
clear
echo "Python environment installed"

echo "Installing Clion."
sudo snap install clion --classic
clear
echo "Clion installed"

echo "Installing PyCharm"
sudo snap install pycharm-community --classic
clear 
echo "PyCharm Installed"

echo "Installing Neovim"
sudo apt install -y neovim
clear
echo "Neovim Installed"

echo "Installing Utilities"
sudo apt install -y rofi fzf xdotool xclip xdg-utils python3-i3ipc breeze-icon-theme lightdm
sudo systemctl enable lightdm
sudo systemctl set-default graphical.target
sudo dpkg-reconfigure lightdm
clear 
echo "Utilities Installed"

echo "Installing Network Manager"
if ! command -v nm-applet >/dev/null; then
    sudo apt install network-manager-gnome -y
fi
clear
echo "Network Manager Installed"

echo "Installing I3 Useful Packages"
sudo apt install -y brightnessctl flameshot
clear
echo "Useful I3 Packages Installed"

echo "Installing Audio Packages"
sudo apt install -y pipewire wireplumber pipewire-pulse pipewire-alsa pipewire-jack
sudo -u "$USER" systemctl --user enable --now wireplumber.service 2>/dev/null || true
clear
echo "Audio Packages Installed"

# create config directories
echo "Creating config directories..."
mkdir -p ~/.config/i3
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/picom
mkdir -p ~/.config/polybar
mkdir -p ~/.icons
mkdir -p ~/.local/bin
mkdir -p ~/.config/nvim

# helper: backup file if exists
backup_if_exists() {
  local path="$1"
  if [ -e "$path" ]; then
    echo "Backing up existing $path -> ${path}.bak.${TIMESTAMP}"
    mv "$path" "${path}.bak.$(date +%s%N)"
  fi
}

# copy config files (only if present in repo)
echo "Copying config files..."
if [ -f "i3/config" ]; then
  backup_if_exists "$HOME/.config/i3/config"
  cp i3/config ~/.config/i3/config
else
  echo "Warning: i3/config not found in repo."
fi

if [ -f "alacritty/alacritty.toml" ]; then
  backup_if_exists "$HOME/.config/alacritty/alacritty.toml"
  cp alacritty/alacritty.toml ~/.config/alacritty/alacritty.toml
else
  echo "Warning: alacritty/alacritty.toml not found in repo."
fi

if [ -f "picom/picom.conf" ]; then
  backup_if_exists "$HOME/.config/picom/picom.conf"
  cp picom/picom.conf ~/.config/picom/picom.conf
else
  echo "Warning: picom/picom.conf not found in repo."
fi

if [ -f "polybar/config.ini" ]; then
  backup_if_exists "$HOME/.config/polybar/config.ini"
  cp polybar/config.ini ~/.config/polybar/config.ini
else
  echo "Warning: polybar/config.ini not found in repo."
fi

if [ -f "nvim/init.lua" ]; then
  backup_if_exists "$HOME/.config/nvim/init.lua"
  cp nvim/init.lua ~/.config/nvim/init.lua
else
  echo "Warning: nvim/init.lua not found in repo."
fi

# fuzzy script: confirm correct repo filename
# I standardize on fuzzy-file-search for target path; adapt if you prefer a different name.
if [ -f "fuzzy-find/fuzzy-find-search" ]; then
  cp fuzzy-find/fuzzy-find-search ~/.local/bin/fuzzy-find-search
  chmod +x ~/.local/bin/fuzzy-find-search
else
  echo "Warning: fuzzy-find/fuzzy-find-search not found. Please add your fuzzy script."
fi

# Left-Handed cursor
if [ -d "icons/oreo-left" ]; then
  echo "Copying left-handed cursor theme..."
  # Backup existing cursor if present
  if [ -d "$HOME/.icons/oreo-left" ]; then
    mv "$HOME/.icons/oreo-left" "$HOME/.icons/oreo-left.bak.$(date +%s)"
  fi
  cp -r icons/oreo-left ~/.icons/
else
  echo "Warning: icons/oreo-left not found in repo."
fi

echo "=================================================================="
echo "Installation finished."
echo "=================================================================="
echo "IMPORTANT i3 AUTOSTART NOTES:"
exho "=================================================================="
echo "Ensure the following lines exist in ~/.config/i3/config:"
echo "=================================================================="
echo "  exec --no-startup-id picom --config ~/.config/picom/picom.conf"
echo "  exec --no-startup-id feh --bg-scale /path/to/your/wallpaper.jpg"
echo "=================================================================="
echo "You may also want:"
echo "  exec --no-startup-id nm-applet"
echo "  exec --no-startup-id polybar main"
echo "=================================================================="
echo "After logging in, reload i3 with \$mod+Shift+r"
echo "Reload i3 with \$mod+Shift+r after logging in."
