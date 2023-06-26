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
NVIDIA_PACKAGES="nvidia-lts lib32-nvidia-utils nvidia-utils nvidia-settings libva-nvidia-driver"  # ignore if no nvidia

# needed directories
mkdir -p $HOME/Documents
mkdir -p $HOME/Downloads
mkdir -p $HOME/Pictures
mkdir -p $HOME/.config
mkdir -p $HOME/.config/zsh
mkdir -p $HOME/.local/state/zsh

# sync and update
sudo pacman -Syu --noconfirm perl

# enable parallel downloads if not already
grep "#ParallelDownloads" /etc/pacman.conf && sudo sed -i 's/#ParallelDownloads/ParallelDownloads/g' /etc/pacman.conf

# install AUR helper
if ! command -v $AUR_WRAPPER &> /dev/null
then
    sudo pacman -S --needed --noconfirm base-devel
    cd ~/Downloads
    git clone https://aur.archlinux.org/$AUR_WRAPPER.git
    cd $AUR_WRAPPER
    makepkg -si
fi

# install base system utils
$AUR_WRAPPER -S --noconfirm xorg-server xorg-xinit xorg-xrandr arandr networkmanager kitty qtile python-psutil python-requests brave-bin rofi zsh exa picom ffmpeg feh mpv lxappearance neofetch htop python-pip bluez bluez-utils polkit docker docker-compose pipewire lib32-pipewire wireplumber pipewire-audio pipewire-alsa pipewire-pulse pavucontrol qpwgraph tldr man-pages man-db dunst betterlockscreen volumeicon blueman caffeine-ng network-manager-applet xdg-user-dirs libva-utils xclip unzip visual-studio-code-bin intel-ucode pacman-contrib

# system fonts and themes
$AUR_WRAPPER -S --noconfirm noto-fonts-emoji ttf-hack-nerd dracula-gtk-theme breeze-gtk xcursor-breeze breeze-icons

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
if ! command -v starship &> /dev/null
then
    curl -sS https://starship.rs/install.sh | sh
fi

if [ ! -d ~/.config/zsh/zsh-autosuggestions ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ~/.config/zsh/zsh-autosuggestions
fi

if [ ! -d ~/.config/zsh/zsh-syntax-highlighting ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.config/zsh/zsh-syntax-highlighting
fi

sudo groupadd docker
sudo usermod -aG tty,audio,video,docker $USER

# enable systemd services
services=( "NetworkManager" "docker" "bluetooth" )
for service in "${services[@]}" 
do
    :
    sudo systemctl enable --now "$service"
done

# enable systemd user services
services=( "pipewire" "pipewire-pulse" )
for service in "${services[@]}" 
do
    :
    systemctl --user enable --now "$service"
done

# sym link config files
home_dir_files=( ".vimrc" ".xinitrc" ".Xresources"  ".zlogin" ".zshenv" ".zshrc" )
cd
for file in "${home_dir_files[@]}" 
do
    :
    ln -sf ~/$REPO_NAME/"$file" .
done

config_dir_files=( "kitty" "neofetch" "qtile" "ranger" "rofi" )
cd ~/.config
for file in "${config_dir_files[@]}" 
do
    :
    ln -sf ~/$REPO_NAME/"$file" .
done

# post script setup
echo "Script Finished Successfully!"
sleep 1
echo "Here is some optional post install configuration"
echo "  - Launch lxapperance and change themes/cursors"
echo "  - Set betterlockscreen using betterlockscreen -u ~/$REPO_NAME/lockscreen.png"
sleep 1

while true; do
    read -p "Do you want to reboot into the system? [Y/n] " yn
    case $yn in
        [Yy]* ) reboot;;
        [Nn]* ) break;;
        "" ) reboot;;
        * ) echo "Please answer yes or no.";;
    esac
done

