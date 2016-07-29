#!/bin/bash

read -n1 -r -p "Press any key to continue..." key
# Update system clock
echo "Setting system clock"
timedatectl set-ntp true

read -n1 -r -p "Press any key to continue..." key
# Get dev
read -p "Path to device (default /dev/sda): " dev_path
dev_path=${dev_path:-/dev/sda}

read -n1 -r -p "Press any key to continue..." key
# Wipe Disk
read -p "Secure erase drive (y/n): " wipe_drive
wipe_drive=${wipe_drive:-n}
if [ "$wipe_drive" == "y" ]; then
  cryptsetup open --type plain $dev_path container --key-file /dev/urandom
  dd if=/dev/zero of=/dev/mapper/container bs=1M status=progress
  cryptsetup close container
fi

read -n1 -r -p "Press any key to continue..." key
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

read -n1 -r -p "Press any key to continue..." key
# Perform full disk encryption and mount partitions
read -p "Passphrase for encrypted volume: " passphrase
cryptsetup -v luksFormat $dev_path"2" <<< $passphrase
cryptsetup open $dev_path"2" cryptroot <<< $passphrase
mkfs -t ext4 /dev/mapper/cryptroot
mkfs -t ext4 $dev_path"1"
mount -t ext4 /dev/mapper/cryptroot /mnt
mkdir /mnt/boot
mount $dev_path"1" /mnt/boot

read -n1 -r -p "Press any key to continue..." key
# Find best packman mirrors
echo "Ranking pacman mirrors"
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
rankmirrors /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist

read -n1 -r -p "Press any key to continue..." key
# Install base system
echo "Installing base system"
pacstrap /mnt base

read -n1 -r -p "Press any key to continue..." key
# Copy mirrorlist to chroot
echo "Copying mirrorlist to new system"
cp /mnt/etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist.backup
cp /etc/pacman.d/mirrorlist /mnt/etc/pacman.d/mirrorlist

read -n1 -r -p "Press any key to continue..." key
#generate fstab
genfstab -p /mnt >> /mnt/etc/fstab

read -n1 -r -p "Press any key to continue..." key
#prepare next script
mv ./1_b_chroot_install.sh /mnt/root/1_b_chroot_install.sh
arch-chroot /mnt chmod +x /root/1_b_chroot_install.sh
arch-chroot /mnt /bin/bash /root/1_b_chroot_install.sh
rm /mnt/root/1_b_chroot_install.sh

read -n1 -r -p "Press any key to continue..." key
umount /mnt/boot
umount /mnt

