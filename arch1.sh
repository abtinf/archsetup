#!/bin/bash

# Update system clock
echo "Setting system clock"
timedatectl set-ntp true

# Get dev
read -p "Path to device (default /dev/sda): " dev_path
dev_path=${dev_path:-/dev/sda}

# Wipe Disk
read -p "Secure erase drive (y/n): " wipe_drive
wipe_drive=${wipe_drive:-n}
if [ "$wipe_drive" == "y"]; then
  cryptsetup open --type plain $dev_path container --key-file /dev/urandom
  dd if=/dev/zero of=/dev/mapper/container bs=1M status=progress
  cryptsetup close container
fi

# Partition Disk
echo "Partitioning disk"
cat<<EOF | fdisk $dev_path
o
n
p
1

+1G
n
p
2


w

EOF

# Perform full disk encryption and mount partitions
read -p "Passphrase for encrypted volume: " passphrase
cryptsetup -v luksFormat $dev_path"2" <<< $passphrase
cryptsetup open $dev_path"2" <<< $passphrase
mkfs -t ext4 /dev/mapper/cryptroot
mkfs -t ext4 $dev_path"1"
mount -t ext4 /dev/mapper/cryptroot /mnt
mkdir /mnt/boot
mount $dev_path"1" /mnt/boot

# Find best packman mirrors
echo "Ranking pacman mirrors"
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
rankmirrors /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist

# Install base system
echo "Installing base system"
pacstrap /mnt base base-devel
pacstrap /mnt intel-ucode grub
pacstrap /mnt xorg xorg-apps xorg-xdm xdm-archlinux spectrwm vim xterm

# Copy mirrorlist to chroot
echo "Copying mirrorlist to new system"
cp /mnt/etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist.backup
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist

#generate fstab
genfstab -p /mnt >> /mnt/etc/fstab

#prepare next script
mv ./arch2.sh /mnt/root/arch2.sh
arch-chroot /mnt chmod +x /root/arch2.sh
arch-chroot /mnt /bin/bash /root/arch2.sh
rm /mnt/root/arch2.sh

umount /mnt/boot
umount /mnt

