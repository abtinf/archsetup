#!/bin/bash

#apps
sudo pacman -S --noconfirm hunspell-en hyphen-en libmythes mythes-en gedit pidgin purple-plugin-pack aspell-en pidgin-otr 
#browsers
sudo pacman -S --noconfirm uzbl-browser firefox surf
yaourt -S --noconfirm google-chrome-dev google-talkplugin minecraft
#printing
sudo pacman -S --noconfirm cups cups-filters ghostscript gsfonts cups-pdf hplip
sudo systemctl enable cups
