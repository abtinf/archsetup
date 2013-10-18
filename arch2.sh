#!/bin/bash

HOSTNAME=""
USERNAME=""

#set time zone
ln -s /usr/share/zoneinfo/America/Chicago /etc/localtime

#set language
mv /etc/locale.gen /etc/locale.gen.backup
sed 's/^#en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/' /etc/locale.gen.backup > /etc/locale.gen
echo LANG=en_US.UTF-8 > /etc/locale.conf
locale-gen

#set hostname
echo $HOSTNAME > /etc/hostname

#set console font
echo FONT=Lat2-Terminus16 > /etc/vconsole.conf

#configure mkinitcpio and generate
mv /etc/mkinitcpio.conf /etc/mkinitcpio.conf.backup
sed 's/ filesystems/ encrypt filesystems/g' /etc/mkinitcpio.conf.backup > /etc/mkinitcpio.conf
mkinitcpio -p linux

#set root password
passwd

#install grub
grub-install /dev/sda
cp /usr/share/locale/en\@quot/LC_MESSAGES/grub.mo /boot/grub/locale/en.mo
mv /etc/default/grub /etc/default/grub.backup
sed 's#^GRUB_CMDLINE_LINUX=""#GRUB_CMDLINE_LINUX="cryptdevice=/dev/sda2:cryptroot"#' /etc/default/grub.backup > /etc/default/grub
pacman -S --noconfirm os-prober
grub-mkconfig -o /boot/grub/grub.cfg

#add user
useradd -m -g users -G wheel,audio,lp,optical,storage,video,games,power,scanner,network -s /bin/bash $USERNAME
passwd $USERNAME

#enable wheel group for sudo
mv /etc/sudoers /etc/sudoers.backup
sed 's/^# %wheel ALL=(ALL) ALL/%wheel ALL=(ALL) ALL/' /etc/sudoers.backup > /etc/sudoers

#sudo password caching
echo Defaults timestamp_timeout=20 >> /etc/sudoers

#disable wierd network interface naming scheme
ln -s /dev/null /etc/udev/rules.d/80-net-name-slot.rules

#Install openssh
pacman -S --noconfirm openssh


#leave chroot
exit

