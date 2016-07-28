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
useradd -m -G wheel -s /bin/bash $username
passwd $username

# Enable wheel group for sudo
mv /etc/sudoers /etc/sudoers.backup
sed 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers.backup > /etc/sudoers

# Sudo password caching
echo Defaults timestamp_timeout=20 >> /etc/sudoers

# Enable display manager
systemctl enable xdm-archlinux.service
echo "exec spectrwm" > /home/$username/.xinitrc
chown $username:$username /home/$username/.xinitrc
chmod +x /home/$username/.xinitrc

# Disable dumb network device naming
ln -s /dev/null /etc/udev/rules.d/80-net-setup-link.rules

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

