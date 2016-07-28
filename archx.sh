#!/bin/bash

#apps
sudo pacman -S --noconfirm audacity inkscape libreoffice-en-US libreoffice-calc libreoffice-impress libreoffice-writer libreoffice-draw gimp hunspell-en hyphen-en libmythes mythes-en gedit pidgin purple-plugin-pack aspell-en pidgin-otr gnucash tightvnc rdesktop
#browsers
sudo pacman -S --noconfirm uzbl-browser firefox filezilla surf
yaourt -S --noconfirm google-chrome-dev google-talkplugin minecraft
#printing
sudo pacman -S --noconfirm cups cups-filters ghostscript gsfonts cups-pdf hplip
sudo systemctl enable cups


#TODO copy or link
    #Thinkpad middle button scrolling /etc/X11/xorg.conf.d/20-thinkpad.conf
    #.Xresources
    #.xinitrc - make executable

#congfigure spectrwm
mkdir ~/scripts
cp /etc/spectrwm.conf ~/.spectrwm.conf
cp /usr/share/spectrwm/screenshot.sh ~/scripts/
sed 's|screenshot.sh|~/scripts/screenshot.sh|' ~/.spectrwm.conf > ~/.spectrwm.confback; mv ~/.spectrwm.confback ~/.spectrwm.conf
sed 's/^# program\[screenshot_all\]/program[screenshot_all]/' ~/.spectrwm.conf > ~/.spectrwm.confback; mv ~/.spectrwm.confback ~/.spectrwm.conf
sed 's/^# program\[screenshot_wind\]/program[screenshot_wind]/' ~/.spectrwm.conf > ~/.spectrwm.confback; mv ~/.spectrwm.confback ~/.spectrwm.conf
sed 's/^# disable_border/disable_border/' ~/.spectrwm.conf > ~/.spectrwm.confback; mv ~/.spectrwm.confback ~/.spectrwm.conf
sed 's/^# bar_at_bottom/bar_at_bottom/' ~/.spectrwm.conf > ~/.spectrwm.confback; mv ~/.spectrwm.confback ~/.spectrwm.conf
sed -r 's/^# title_name_enabled\s+= 0/title_name_enabled    = 1/' ~/.spectrwm.conf > ~/.spectrwm.confback; mv ~/.spectrwm.confback ~/.spectrwm.conf
sed -r 's/^# window_name_enabled\s+= 0/window_name_enabled   = 1/' ~/.spectrwm.conf > ~/.spectrwm.confback; mv ~/.spectrwm.confback ~/.spectrwm.conf
sed -r 's/^# program\[lock\]\s+= xlock/program[lock]         = slock/' ~/.spectrwm.conf > ~/.spectrwm.confback; mv ~/.spectrwm.confback ~/.spectrwm.conf
sed -r 's/^# bar_border_width\s+= 1/bar_border_width = 0/' ~/.spectrwm.conf > ~/.spectrwm.confback; mv ~/.spectrwm.confback ~/.spectrwm.conf

cat >> ~/.spectrwm.conf <<EOL
program[raise_volume]    = amixer set Master 5%+ unmute
bind[raise_volume]    = XF86AudioRaiseVolume
program[lower_volume]    = amixer set Master 5%- unmute
bind[lower_volume]    = XF86AudioLowerVolume
program[mute_volume]    = amixer set Master toggle
bind[mute_volume]    = XF86AudioMute
program[screensaver]    = slock
bind[screensaver]    = XF86ScreenSaver
program[chrome]    = google-chrome
bind[chrome]        = MOD+F1
EOL
