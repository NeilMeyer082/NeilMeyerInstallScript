#!/usr/bin/env bash
set -euo pipefail

# ----- Wi-Fi Setup -----
echo "Scanning for available Wi-Fi networks..."
nmcli device wifi rescan >/dev/null 2>&1 || true
sleep 3
nmcli device wifi list

read -rp "Do you want to connect to a Wi-Fi network before continuing? [y/N]: " wifi_answer
wifi_answer=${wifi_answer,,}

if [[ "$wifi_answer" == "y" || "$wifi_answer" == "yes" ]]; then
    read -rp "Enter SSID to connect to: " wifi_ssid
    read -rsp "Enter password for '$wifi_ssid' (leave blank if open network): " wifi_pass
    echo

    if [[ -z "$wifi_pass" ]]; then
        nmcli device wifi connect "$wifi_ssid"
    else
        nmcli device wifi connect "$wifi_ssid" password "$wifi_pass"
    fi
fi

# ----- System Updates -----
echo "Updating Ubuntu..."
sudo apt update && sudo apt upgrade -y

# ----- Display Server & Drivers -----
echo "Installing Xorg Display Server..."
sudo apt install -y xserver-xorg xserver-xorg-core xserver-xorg-video-all x11-xserver-utils

echo "Detecting Graphics Hardware..."
# Detect GPU
if lspci | grep -iq "nvidia"; then
    echo "Nvidia GPU detected. Installing proprietary drivers..."
    sudo add-apt-repository ppa:graphics-drivers/ppa -y
    sudo apt update
    sudo ubuntu-drivers autoinstall
elif lspci | grep -iq "amd"; then
    echo "AMD GPU detected. Installing Mesa drivers..."
    sudo apt install -y mesa-vulkan-drivers libvulkan1 mesa-va-drivers mesa-vdpau-drivers
elif lspci | grep -iq "intel"; then
    echo "Intel Graphics detected. Installing standard drivers..."
    sudo apt install -y intel-media-va-driver-non-free libmfx1
fi

# ----- Tool Installation -----
echo "Installing Core Utilities & Dependencies..."
sudo apt install -y software-properties-common git curl unzip xdg-utils wget fontconfig

echo "Installing Desktop Environment (i3, Polybar, etc)..."
sudo apt install -y i3 polybar alacritty i3lock feh picom lxappearance thunar \
thunar-archive-plugin file-roller gvfs-backends gvfs-fuse rofi fzf xdotool xclip \
python3-i3ipc breeze-icon-theme lightdm network-manager-gnome brightnessctl flameshot

echo "Installing Media & Productivity..."
sudo apt install -y obs-studio audacity kdenlive libreoffice vlc

echo "Installing Dev Tools..."
sudo apt install -y rustc cargo python3 python3-pip python3-venv 

# Snaps
sudo snap install pyright --classic
sudo snap install firefox
sudo snap install chromium
sudo snap install clion --classic
sudo snap install pycharm-community --classic

# Rust-Analyzer (Direct binary)
echo "Installing rust-analyzer..."
mkdir -p ~/.local/bin
curl -L https://github.com/rust-lang/rust-analyzer/releases/latest/download/rust-analyzer-x86_64-unknown-linux-gnu.gz | gunzip > ~/.local/bin/rust-analyzer
chmod +x ~/.local/bin/rust-analyzer

# ----- Fresh Text Editor Installation -----
echo "Installing Fresh Text Editor..."
FRESH_URL=$(curl -s https://api.github.com/repos/sinelaw/fresh/releases/latest | grep "browser_download_url.*_$(dpkg --print-architecture)\.deb" | cut -d '"' -f 4)
curl -sL "$FRESH_URL" -o fresh-editor.deb
sudo dpkg -i fresh-editor.deb || sudo apt-get install -f -y 
rm fresh-editor.deb

# ----- Font Installation -----
echo "Installing Fonts..."
sudo apt install -y fonts-croscore fonts-crosextra-caladea fonts-crosextra-carlito
echo "Installing JetBrainsMono Nerd Font..."
mkdir -p ~/.local/share/fonts
wget -q --show-progress https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
unzip -o JetBrainsMono.zip -d ~/.local/share/fonts
rm JetBrainsMono.zip
fc-cache -fv

# ----- Audio Setup -----
echo "Setting up Audio (Pipewire)..."
sudo apt install -y pipewire wireplumber pipewire-pulse pipewire-alsa pipewire-jack
systemctl --user enable --now wireplumber.service || true

# ----- Configuration Handling -----
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
mkdir -p ~/.config/{i3,alacritty,picom,polybar} ~/.icons ~/.local/bin

backup_and_cp() {
    local src="$1"
    local dest="$2"
    if [ -f "$src" ]; then
        if [ -f "$dest" ]; then
            mv "$dest" "$dest.bak.$TIMESTAMP"
        fi
        cp "$src" "$dest"
    else
        echo "Warning: Local config $src not found. Skipping."
    fi
}

backup_and_cp "i3/config" "$HOME/.config/i3/config"
backup_and_cp "alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
backup_and_cp "picom/picom.conf" "$HOME/.config/picom/picom.conf"
backup_and_cp "polybar/config.ini" "$HOME/.config/polybar/config.ini"
backup_and_cp "polybar/launch.sh" "$HOME/.config/polybar/launch.sh"
[ -f "$HOME/.config/polybar/launch.sh" ] && chmod +x "$HOME/.config/polybar/launch.sh"

if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
fi

# Set LightDM as default
sudo systemctl enable lightdm
sudo systemctl set-default graphical.target

echo "=================================================================="
echo "Installation finished! Please reboot to enter your i3 environment."
echo "=================================================================="
