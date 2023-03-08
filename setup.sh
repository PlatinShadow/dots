#!/bin/bash
TMP_DIR="/tmp/epic-setup"

mkdir $TMP_DIR
cd $TMP_DIR

# Install packages
X11_PACKAGES="xorg"
DESKTOP_PACKAGES="lightdm polybar picom dunst rofi bspwm sxhkd zsh feh neofetch imagemagick"
UTILITY_PACKAGES="git wget unzip python3"

echo -n "Do you want to install nvidia drivers? (yes/no)"
read userInput
if [ "$userInput" = "yes" ]; then
    X11_PACKAGES="nvidia-driver xserver-xorg-video-nvidia xserver-xorg-core xinit"
fi

# Enable non-free packages for nvidia driver
if ! grep -q non-free /etc/apt/sources.list; then
    sudo sed -i 's/main/main contrib non-free/g' /etc/apt/sources.list
fi

sudo apt-get update 
sudo apt-get -y install $X11_PACKAGES $DESKTOP_PACKAGES $UTILITY_PACKAGES
sudo pip3 install pywal

#Confiure Xorg and Lightdm
sudo Xorg -configure
sudo dpkg-reconfigure lightdm

# Add BSPWM Entry
sudo echo -e "[Desktop Entry]\nName=bspwm\nComment=Binary space partitioning window manager\nExec=bspwm\nType=Application" > /usr/share/xsessions/bspwm.desktop
sudo rm /usr/share/xsessions/lightdm-xsession.desktop

# Pull dots git repo
git clone https://github.com/PlatinShadow/dots.git
sudo mv dots $HOME/.config/dots
sudo ln -s $HOME/.config/dots/.config/scripts $HOME/.config/scripts
sudo ln -s $HOME/.config/dots/.config/bspwm $HOME/.config/bspwm
sudo ln -s $HOME/.config/dots/.config/picom $HOME/.config/picom
sudo ln -s $HOME/.config/dots/.config/polybar $HOME/.config/polybar
sudo ln -s $HOME/.config/dots/.config/rofi $HOME/.config/rofi
sudo ln -s $HOME/.config/dots/.config/sxhkd $HOME/.config/sxhkd
sudo ln -s $HOME/.config/dots/.config/.zshrc $HOME/.zshrc

# Setup Fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Meslo.zip -O Meslo.zip
unzip Meslo.zip -d Meslo
sudo mv Meslo/*.ttf /usr/share/fonts/truetype
sudo cd /usr/share/fonts/truetype
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

# DONE
#clear
echo Done! Setup Complete 
neofetch
echo TODO: Set ZSH_THEME="powerlevel10k/powerlevel10k" in ~/.zshrc
echo You may now reboot