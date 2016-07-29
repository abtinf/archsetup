#!/bin/bash

# Networking
sudo ip link set eth0 up
sudo ip link set wlan0 up

#windows name lookup
#sudo pacman -S --noconfirm avahi nss-mdns
#sudo systemctl enable avahi-daemon.service
#sudo bash -c "sed 's/^hosts: files dns myhostname/hosts: files myhostname mdns_minimal [NOTFOUND=return] dns/' /etc/nsswitch.conf > /etc/nsswitch.confback; mv /etc/nsswitch.confback /etc/nsswitch.conf"

#disable sleep on close
#sudo bash -c "sed 's/^#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' /etc/systemd/logind.conf > /etc/systemd/logind.confback; mv /etc/systemd/logind.confback /etc/systemd/logind.conf"
#sudo bash -c "sed 's/^#HandleHibernateKey=hibernate/HandleHibernateKey=ignore/' /etc/systemd/logind.conf > /etc/systemd/logind.confback; mv /etc/systemd/logind.confback /etc/systemd/logind.conf"

#AUR helper
cd /tmp
wget https://aur.archlinux.org/packages/pa/package-query/package-query.tar.gz
tar xzf package-query.tar.gz
cd package-query
makepkg -si
cd ..
cd /tmp
wget https://aur.archlinux.org/packages/ya/yaourt/yaourt.tar.gz
tar xzf yaourt.tar.gz
cd yaourt
makepkg -si
cd ~
