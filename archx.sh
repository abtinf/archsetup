#!/bin/bash

#servers
sudo pacman -S --noconfirm xorg-server xorg-server-utils xorg-xinit xf86-video-intel xf86-input-synaptics xterm slim slim-themes archlinux-themes-slim spectrwm scrot slock
#fonts
sudo pacman -S --noconfirm ttf-dejavu artwiz-fonts ttf-droid ttf-inconsolata ttf-freefont ttf-liberation xorg-fonts-type1
#apps
sudo pacman -S --noconfirm audacity inkscape libreoffice-en-US libreoffice-calc libreoffice-impress libreoffice-writer libreoffice-draw gimp hunspell-en hyphen-en libmythes mythes-en gedit pidgin purple-plugin-pack aspell-en pidgin-otr gnucash tightvnc rdesktop
#browsers
sudo pacman -S --noconfirm uzbl-browser firefox filezilla surf
yaourt -S --noconfirm google-chrome-dev google-talkplugin minecraft
#printing
sudo pacman -S --noconfirm cups cups-filters ghostscript gsfonts cups-pdf hplip
sudo systemctl enable cups
#media
sudo pacman -S --noconfirm libdvdread libdvdcss libdvdnav vlc

#strart display manager on boot
sudo systemctl enable slim.service

#configure xinitrc
cat > ~/.xinitrc <<EOL
xrdb ~/.Xresources &
exec \$1
EOL
chmod +x ~/.xinitrc

#Thinkpad middle button scrolling
sudo bash -c 'cat > /etc/X11/xorg.conf.d/20-thinkpad.conf <<EOL
Section "InputClass"
    Identifier         "Trackpoint Wheel Emulation"
    MatchProduct       "TPPS/2 IBM TrackPoint|DualPoint Stick|Synaptics Inc. Composite TouchPad / TrackPoint|ThinkPad USB Keyboard with TrackPoint|USB Trackpoint pointing device|Composite TouchPad / TrackPoint"
    MatchDevicePath    "/dev/input/event*"
    Option             "EmulateWheel" "true"
    Option             "EmulateWheelButton" "2"
    Option             "Emulate3Buttons" "false"
    Option             "XAxisMapping" "6 7"
    Option             "YAxisMapping" "4 5"
    Option             "ButtonMapping" "1 1 3 4 5"
EndSection
EOL'

#configure xterm
cat > ~/.Xresources <<EOL
xterm*faceName: Liberation Mono:size=10:antialias=false
xterm*font: 7x13
xterm*locale: true
xterm*saveLines: 4096
xterm*jumpScroll: true

xterm*foreground: rgb:b2/b2/b2
xterm*background: rgb:08/08/08
EOL

#configure slim theme
sudo mv /etc/slim.conf /etc/slim.conf.backup
sudo bash -c "sed 's/^current_theme       default/current_theme       archlinux-simplyblack/' /etc/slim.conf.backup > /etc/slim.conf" 

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
