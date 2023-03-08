#!/bin/bash
TMP_DIR="/tmp/epic-setup"

mkdir $TMP_DIR
cd $TMP_DIR

# Install packages
X11_PACKAGES="xorg"
DESKTOP_PACKAGES="lightdm polybar dunst rofi bspwm sxhkd zsh feh neofetch imagemagick"
UTILITY_PACKAGES="git wget unzip python3"
PICOM_DEPS="libxext-dev libxcb1-dev libxcb-damage0-dev libxcb-dpms0-dev libxcb-xfixes0-dev libxcb-shape0-dev libxcb-render-util0-dev libxcb-render0-dev libxcb-randr0-dev libxcb-composite0-dev libxcb-image0-dev libxcb-present-dev libxcb-glx0-dev libpixman-1-dev libdbus-1-dev libconfig-dev libgl-dev libegl-dev libpcre2-dev libevdev-dev uthash-dev libev-dev libx11-xcb-dev meson build-essential ninja-build"

echo -n "Do you want to install nvidia drivers? (yes/no)"
read userInput
if [ "$userInput" = "yes" ]; then
    X11_PACKAGES="nvidia-driver xserver-xorg-video-nvidia xserver-xorg-core xinit"
fi

# Enable non-free packages for nvidia driver
if ! grep -q non-free /etc/apt/sources.list; then
    sudo sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list
fi

# Get new packages
sudo apt-get update 
sudo apt-get -y install git

# Pull dots git repo
git clone https://github.com/PlatinShadow/dots.git
mkdir $HOME/.config
sudo mv dots $HOME/.config/dots
sudo ln -s $HOME/.config/dots/.config/bspwm $HOME/.config/bspwm
sudo ln -s $HOME/.config/dots/.config/picom $HOME/.config/picom
sudo ln -s $HOME/.config/dots/.config/polybar $HOME/.config/polybar
sudo ln -s $HOME/.config/dots/.config/rofi $HOME/.config/rofi
sudo ln -s $HOME/.config/dots/.config/sxhkd $HOME/.config/sxhkd

# Download all packages
sudo apt-get -y install $X11_PACKAGES $DESKTOP_PACKAGES $UTILITY_PACKAGES $PICOM_DEPS
sudo pip3 install pywal

#Confiure Xorg and Lightdm
Xorg -configure
sudo dpkg-reconfigure lightdm

# Add BSPWM Entry
sudo echo -e "[Desktop Entry]\nName=bspwm\nComment=Binary space partitioning window manager\nExec=bspwm\nType=Application" > /usr/share/xsessions/bspwm.desktop
sudo rm /usr/share/xsessions/lightdm-xsession.desktop

# Compile picom
git clone https://github.com/yshui/picom.git
cd picom
git submodule update --init --recursive
meson setup --buildtype=release . build
ninja -C build
ninja -C build install
cd $TMP_DIR

# Setup Fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Meslo.zip -O Meslo.zip
unzip Meslo.zip -d Meslo
sudo mv Meslo/*.ttf /usr/share/fonts/truetype
cd /usr/share/fonts/truetype
sudo mkfontscale
sudo mkfontdir
sudo fc-cache
sudo xset fp rehash
cd $TMP_DIR

# Setup Services
sudo systemctl disable NetworkManager-wait-online.service
sudo systemctl enable lightdm

# Setup Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
rm $HOME/.zshrc
sudo ln -s $HOME/.config/dots/.config/.zshrc $HOME/.zshrc

# DONE
#clear
neofetch
echo Done! Reboot to complete setup