#!/bin/bash

# Set time zone
read -p "Timezone (default /America/Los_Angeles): " timezone
timezone=${timezone:-/America/Los_Angeles}
ln -s "/usr/share/zoneinfo"$timezone /etc/localtime
hwclock --systohc --utc

# Set language
echo "Setting locale to en_US.UTF-8"
mv /etc/locale.gen /etc/locale.gen.backup
sed 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen.backup > /etc/locale.gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
locale-gen

# Set hostname
read -p "Hostname: " hostname
echo $hostname > /etc/hostname
# TODO add hostname to hosts file

# Set root password
echo "Enter a root password (root will also be disabled)"
passwd
passwd -l root

# Add user
read -p "Username: " username
useradd -m -G wheel,storage -s /bin/bash $username
passwd $username

# Enable wheel group for sudo
mv /etc/sudoers /etc/sudoers.backup
sed 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers.backup > /etc/sudoers

# Sudo password caching
echo Defaults timestamp_timeout=20 >> /etc/sudoers

# Install useful packages
# Essential
pacman -S --noconfirm base-devel intel-ucode grub
# Networking
pacman -S --noconfirm dialog wpa_supplicant ifplugd iw wpa_actiond ufw
# Utilities
pacman -S --noconfirm ntp openssh wget arch-wiki-lite unzip rsync ed vim bash-completion alsa-utils mc colordiff iotop pkgfile htop udisks2 udevil ntfs-3g parted
# Development tools
pacman -S --noconfirm git mercurial svn cvs bzr perl python ruby go gcc nodejs tcl tk qt4 poppler-glib
# X and display manager
pacman -S --noconfirm xorg xorg-apps xorg-xdm xdm-archlinux
# Window manager and desktop environment
pacman -S --noconfirm xterm spectrwm scrot slock xautolock
# Fonts
pacman -S --noconfirm ttf-dejavu artwiz-fonts ttf-droid ttf-inconsolata ttf-freefont ttf-liberation xorg-fonts-type1
# Media
pacman -S --noconfirm libdvdread libdvdcss libdvdnav libcdio vlc youtube-dl
# Productivity
pacman -S --noconfirm texlive-most zim audacity inkscape gimp gnucash tigervnc rdesktop libreoffice-still filezilla


# Pull scripts
pacman -S --noconfirm git
cd /home/$username
su - $username -c 'git clone https://github.com/abtinf/archsetup.git'
# Create config symlinks
su - $username -c 'ln -s ./archsetup/config/.Xresources    ~/.Xresources'
su - $username -c 'ln -s ./archsetup/config/.xinitrc       ~/.xinitrc'
su - $username -c 'ln -s ./archsetup/config/.bashrc        ~/.bashrc'
su - $username -c 'ln -s ./archsetup/config/.inputrc       ~/.inputrc'
su - $username -c 'ln -s ./archsetup/config/.spectrwm.conf ~/.spectrwm.conf'
su - $username -c 'ln -s ./archsetup/config/.conkyrc       ~/.conkyrc'
su - $username -c 'ln -s ./archsetup/config/.vimrc         ~/.vimrc'

# External storage manager
systemctl enable udisks2.service
systemctl enable devmon@$username.service
chmod -s /usr/bin/udevil
cp ./archsetup/config/50-udiskie.rules /etc/polkit-1/rules.d/
cp ./archsetup/config/99-udisks2.rules /etc/udev/rules.d/

# Enable display manager
systemctl enable xdm-archlinux.service
chmod +x /home/$username/.xinitrc

# Disable dumb network device naming
ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules
# Enable netctl
sudo systemctl enable netctl-ifplugd@eth0.service
sudo systemctl enable netctl-auto@wlan0.service
# Firewall
ufw enable
ufw default deny
systemctl enable ufw

# Update pkgfile for command no found hook
sudo pkgfile --update

# Configure git
read -p "Git username: " git_username
su - $username -c 'git config --global user.name $git_username'
read -p "Git email: " git_email
su - $username -c 'git config --global user.email $git_email'
su - $username -c 'git config --global core.autocrlf input'

# Update ruby gems
gem update --system
su - $username -c 'gem update'

# Sync clock and enable network time daemon
ntpd -qg
systemctl enable ntpd

# Add encryption hook to mkinitcpio and generate
mv /etc/mkinitcpio.conf /etc/mkinitcpio.conf.backup
sed 's/ filesystems/ encrypt filesystems/g' /etc/mkinitcpio.conf.backup > /etc/mkinitcpio.conf
mkinitcpio -p linux

# Install grub
read -p "Path to device (default /dev/sda): " dev_path
dev_path=${dev_path:-/dev/sda}
mv /etc/default/grub /etc/default/grub.backup
sed 's#^GRUB_CMDLINE_LINUX=""#GRUB_CMDLINE_LINUX="cryptdevice='$dev_path'2:cryptroot"#' /etc/default/grub.backup > /etc/default/grub
grub-install $dev_path
grub-mkconfig -o /boot/grub/grub.cfg

# Leave chroot
exit

