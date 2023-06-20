#!/bin/sh

# exit on error
set -e

# We cannot run as root since we modify files in the user's $HOME dir
if [ "$(id -u)" = 0 ]; then
    echo "ERROR: Cannot run as root"
    exit 1
fi

if [ "$(grep '#\[multilib\]' /etc/pacman.conf)" ]; then
    echo "ERROR: You must enable multilib repo"
    exit 1
fi

# global vars
REPO_NAME=$(basename `git rev-parse --show-toplevel`)
AUR_WRAPPER=paru  # 'paru' or 'yay'
NVIDIA_PACKAGES="nvidia-lts lib32-nvidia-utils nvidia-utils nvidia-settings"  # ignore if no nvidia

# needed directories
mkdir -p $HOME/Documents
mkdir -p $HOME/Downloads
mkdir -p $HOME/Pictures
mkdir -p $HOME/.config
mkdir -p $HOME/.config/zsh

# sync and update
sudo pacman -Syu --noconfirm perl

# enable parallel downloads if not already
grep "#ParallelDownloads" /etc/pacman.conf && sudo sed -i 's/#ParallelDownloads/ParallelDownloads/g' /etc/pacman.conf

# install AUR helper
if ! command -v $AUR_HELPER &> /dev/null
then
    sudo pacman -S --needed --noconfirm base-devel
    cd ~/Downloads
    git clone https://aur.archlinux.org/$AUR_WRAPPER.git
    cd $AUR_WRAPPER
    makepkg -si
fi

# install base system utils
$AUR_WRAPPER -S xorg networkmanager kitty qtile python-psutil brave-bin rofi zsh exa picom ffmpeg feh mpv lxappearance neofetch htop python-pip bluez bluez-utils polkit lxqt-policykit docker docker-compose pipewire lib32-pipewire pavucontrol wireplumber

# system fonts and themes
yay -S noto-fonts-emoji ttf-hack-nerd dracula-gtk-theme breeze

# install python dependencies for desktop
pip install requests

# ask to install nvidia
while true; do
    read -p "Do you want to install nvidia drivers? [Y/n] " yn
    case $yn in
        [Yy]* ) $AUR_WRAPPER -S --noconfirm $NVIDIA_PACKAGES; break;;
        "" ) $AUR_WRAPPER -S --noconfirm $NVIDIA_PACKAGES; break;;
        [Nn]* ) break;;
        * ) echo "Please answer yes or no.";;
    esac
done

# setup shell
chsh -s $(which zsh)
curl -sS https://starship.rs/install.sh | sh
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh/

# enable systemd services
services = ( "NetworkManager" "docker" "bluetooth" "pipewire" )
for service in "${services[@]}" 
do
    :
    sudo systemctl enable --now "$service"
done

# sym link config files
home_dir_files = ( ".vimrc" ".xinitrc" ".zlogin" ".zshenv" )
cd
for file in "${home_dir_files[@]}" 
do
    :
    ln -s ~/$REPO_NAME/"$file" .
done

config_dir_files = ( "kitty" "neofetch" "qtile" "ranger" "rofi" )
cd ~/.config
for file in "${config_dir_files[@]}" 
do
    :
    ln -s ~/$REPO_NAME/"$file" .
done

# post script setup
echo "Script Finished Successfully!"
sleep 1
echo "\nHere is some optional post install configuration"
echo "\t- Launch lxapperance and change themes/cursors"
sleep 1

while true; do
    read -p "Do you want to reboot to get your dtos? [Y/n] " yn
    case $yn in
        [Yy]* ) reboot;;
        [Nn]* ) break;;
        "" ) reboot;;
        * ) echo "Please answer yes or no.";;
    esac
done

