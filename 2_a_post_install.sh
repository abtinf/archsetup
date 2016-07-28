#!/bin/bash

# Utilities
sudo pacman -S --noconfirm openssh wget arch-wiki-lite unzip rsync ed vim bash-completion


#Utilities
sudo pacman -S --noconfirm alsa-utils mc colordiff iotop pkgfile htop

#update pkgfile for command no found hook
sudo pkgfile --update

#dev tools
sudo pacman -S --noconfirm git mercurial svn cvs bzr perl python ruby go gcc nodejs tcl tk

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


#Get rid of annoying beep and enhance tab completion
cat > ~/.inputrc <<EOL
set bell-style none
set show-all-if-ambiguous on
EOL


#configure firewall
sudo pacman -S --noconfirm ufw
sudo ufw enable
sudo ufw default deny
sudo systemctl enable ufw


#lock the root user
sudo passwd -l root


#todo copy or link
  #.bashrc
  #.vimrc

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
