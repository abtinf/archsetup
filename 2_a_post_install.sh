#!/bin/bash

#update pkgfile for command no found hook
sudo pkgfile --update

#configure git
read -p "Git username: " git_username
git config --global user.name $git_username
read -p "Git email: " git_email
git config --global user.email $git_email
git config --global core.autocrlf input

#update ruby gems
sudo gem update --system
gem update

#windows name lookup
#sudo pacman -S --noconfirm avahi nss-mdns
#sudo systemctl enable avahi-daemon.service
#sudo bash -c "sed 's/^hosts: files dns myhostname/hosts: files myhostname mdns_minimal [NOTFOUND=return] dns/' /etc/nsswitch.conf > /etc/nsswitch.confback; mv /etc/nsswitch.confback /etc/nsswitch.conf"

#disable sleep on close
#sudo bash -c "sed 's/^#HandleLidSwitch=suspend/HandleLidSwitch=ignore/' /etc/systemd/logind.conf > /etc/systemd/logind.confback; mv /etc/systemd/logind.confback /etc/systemd/logind.conf"
#sudo bash -c "sed 's/^#HandleHibernateKey=hibernate/HandleHibernateKey=ignore/' /etc/systemd/logind.conf > /etc/systemd/logind.confback; mv /etc/systemd/logind.confback /etc/systemd/logind.conf"


#sync clock and enable network time daemon
#sudo pacman -S --noconfirm ntp
#sudo ntpd -qg
#sudo systemctl enable ntpd

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
