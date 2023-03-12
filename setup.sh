#!/bin/bash
TMP_DIR="/tmp/rice-setup"

mkdir $TMP_DIR
cd $TMP_DIR

# Install packages
DESKTOP_PACKAGES="polybar picom dunst rofi bspwm sxhkd zsh feh neofetch imagemagick unclutter xorg-xsetroot" 
UTILITY_PACKAGES="git wget unzip python3 python-pip"

PM_UPDATE_COMMAND="pacman -Syu"
PM_INSTALL_COMMAND="pacman -S"

#install graphics driver
sudo mhwd -a pci nonfree 0300

# Get new packages
sudo $PM_UPDATE_COMMAND
sudo $PM_INSTALL_COMMAND $UTILITY_PACKAGES

# Pull dots git repo
git clone https://github.com/PlatinShadow/dots.git
mkdir $HOME/.config
sudo mv dots $HOME/.config/dots
sudo ln -s $HOME/.config/dots/config/bspwm $HOME/.config/bspwm
sudo ln -s $HOME/.config/dots/config/picom $HOME/.config/picom
sudo ln -s $HOME/.config/dots/config/polybar $HOME/.config/polybar
sudo ln -s $HOME/.config/dots/config/rofi $HOME/.config/rofi
sudo ln -s $HOME/.config/dots/config/sxhkd $HOME/.config/sxhkd
sudo rm -rf $HOME/.config/gtk-3.0
sudo rm -rf $HOME/.config/gtk-4.0
sudo ln -s $HOME/.config/dots/config/gtk-3.0 $HOME/.config/gtk-3.0
sudo ln -s $HOME/.config/dots/config/gtk-4.0 $HOME/.config/gtk-4.0

# Download all packages
sudo $PM_INSTALL_COMMAND $DESKTOP_PACKAGES
sudo pip3 install pywal

# Setup Fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Meslo.zip -O Meslo.zip
unzip Meslo.zip -d Meslo
sudo mkdir -p /usr/local/share/fonts/ttf
sudo mv Meslo/*.ttf /usr/local/share/fonts/ttf
sudo fc-cache
#cd $TMP_DIR

# Setup Services
#sudo systemctl disable NetworkManager-wait-online.service

# Setup Oh My Zsh
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" && exit

#git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

#sudo rm $HOME/.zshrc $HOME/.p10k.zsh
#sudo ln -s $HOME/.config/dots/config/.zshrc $HOME/.zshrc
#sudo ln -s $HOME/.config/dots/config/.p10k.zsh $HOME/.p10k.zsh

# Setup pywal in zsh
echo wal -i \$HOME/.config/dots/wallpaper/wallpaper.jpg \> /dev/null >> ~/.zshrc
echo . "\${HOME}/.cache/wal/colors.sh" >> ~/.zshrc


# DONE
neofetch
echo Done! Reboot to complete setup
