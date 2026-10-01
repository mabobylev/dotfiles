#!/usr/bin/env bash

# Добавление пользователя в группы и назначение BASH в качестве оболочки по-умолчанию
useradd -m -g users -G audio,video,lp,games,power,storage,wheel -s /bin/bash bma

# Setting up the locale
sudo setfont Cyr_a8x16
# echo "FONT=Cyr_a8x16" > /etc/vconsole.conf
sudo localectl set-locale LANG=ru_RU.UTF-8
# echo "LANG=ru_RU.UTF-8" > /etc/locale.conf
sudo loadkeys ruwin_cplk-UTF-8
sudo localectl set-keymap ruwin_cplk-UTF-8
sudo localectl --no-convert set-x11-keymap us,ru "" pc105 grp:shift_toggle,terminate:ctrl_alt_bksp

### Checking for git package
if ! type -p git &>/dev/null; then
	printf "Устанавливаю GIT ...\n"
	sudo pacman --needed --noconfirm -S git
fi

### Prepare for installation
# Checking for paru package
if ! type -p paru &>/dev/null; then
	printf "Устанавливаю paru ...\n"
	git clone https://aur.archlinux.org/paru.git $git_dir && cd $git_dir/paru && makepkg -si
fi

### Installation applications from the list
### List of applications required for installation
#apps=(adapta-gtk-theme alacritty alsa-utils amd-ucode arc-gtk-theme archlinux-wallpaper arm-none-eabi-gcc arm-none-eabi-gdb audacity avrdude avr-gdb awesome-terminal-fonts base base-devel bash-completion bash-preexec blueberry ccache chezmoi cmake cups curl dunst efibootmgr elementary-icon-theme epapirus-icon-theme eza fastfetch fd firefox-i18n-ru fish fisher fzf galculator gcolor3-xorg gearlever ghidra gimp glava gpicview gtk-engines gucharmap helix htop i3blocks i3-wm john jq lazygit lib32-libpipewire libreoffice-fresh-ru libtermkey lightdm-gtk-greeter-settings linux-headers luit lxappearance-gtk3 man-db materia-gtk-theme meson mkinitcpio-utils mlocate mpv nano nemo-emblems nemo-fileroller nemo-image-converter nemo-preview nemo-seahorse neovim nordic-wallpapers-git papirus-icon-theme pass pavucontrol picom pkgfile pwndbg ranger reflector ripgrep rsync sassc smartmontools starship thefuck tldr tmux tokyonight-gtk-theme-git ttf-hack-nerd ttf-jetbrains-mono-nerd ttf-roboto-mono-nerd ttf-ubuntu-mono-nerd ttf-ubuntu-nerd usbasp-udev visual-studio-code-bin wget wireless_tools wmctrl xarchiver xbitmaps xcursor-simp1e-tokyo-night xdg-user-dirs xdg-user-dirs-gtk xdotool xed xf86-video-amdgpu xf86-video-ati xorg-fonts-cyrillic xorg-font-util xorg-xcursorgen xorg-xinit xorg-xprop zoxide)
#paru -S --needed ${apps[@]}
paru -S --noconfirm --needed <pkglist.txt

### Установка cht.sh
curl https://cht.sh/:cht.sh >"$HOME/.local/bin/cht.sh"
curl https://cheat.sh/:bash_completion >$HOME/.bash.d/bash_cht.sh

### Firefox UI Fix
bash -c "$(curl -fsSL https://raw.githubusercontent.com/black7375/Firefox-UI-Fix/master/install.sh)"

### Установка плагинов fish
fisher install nickeb96/puffer-fish
fisher install axkirillov/tokyonight-fish
fisher install kidonng/zoxide.fish
fisher install jorgebucaran/autopair.fish
fisher install PatrickF1/fzf.fish

ln -sf /usr/share/fontconfig/conf.avail/10-nerd-font-symbols.conf /etc/fonts/conf.d/

# Установка Alacritty терминалом по-умолчанию
gsettings set org.cinnamon.desktop.default-applications.terminal exec alacritty
gsettings set org.gnome.desktop.default-applications.terminal exec alacritty
dconf update
