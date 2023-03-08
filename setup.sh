TMP_DIR="/tmp/epic-setup"

mkdir $TMP_DIR
cd $TMP_DIR

# Install packages
sudo apt-get update 
sudo apt-get -y install curl wget polybar picom dunst rofi bspwm sxhd zsh feh git unzip xfonts-utils neofetch

# Setup Fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v2.3.3/Meslo.zip -O Meslo.zip
unzip Meslo.zip -d Meslo
mv Meslo/*.ttf /usr/share/fonts/truetype
cd /usr/share/fonts/truetype
mkfontscale
mkfontdir
fc-cache
xset fp rehash
cd $TMP_DIR

# Setup Oh My Zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k

# Download useful apps
## Spotify
curl -sS https://download.spotify.com/debian/pubkey_7A3A762FAFD4A51F.gpg | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
echo "deb http://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
sudo apt-get update && sudo apt-get -y install spotify-client

## Discord
wget https://discord.com/api/download\?platform\=linux\&format\=deb-O discord.deb
sudo dpkg -i discord.deb

## VS Code
wget https://go.microsoft.com/fwlink/?LinkID=760868 -O vscode.deb
sudo dpkg -i vscode.deb

# Disable services slowing the boot process
sudo systemctl disable NetworkManager-wait-online.service

# DONE
clear
echo Done! Setup Complete :)
neofetch
echo TODO: Set ZSH_THEME="powerlevel10k/powerlevel10k" in ~/.zshrc
echo You may now reboot