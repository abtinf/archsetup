#!/bin/bash

PASSPHRASE=""

#partition disk
cat<<EOF | fdisk /dev/sda
o
n
p
1

+200M
n
p
2


w

EOF


#perform full disk encryption and mount partitions
modprobe dm_mod
modprobe dm-crypt
cat <<EOF | cryptsetup --cipher aes-xts-plain64 --key-size 512 luksFormat /dev/sda2
$PASSPHRASE
EOF
cat <<EOF | cryptsetup luksOpen /dev/sda2 cryptroot
$PASSPHRASE
EOF
mkfs.ext4 /dev/mapper/cryptroot
mkfs.ext4 /dev/sda1
mount /dev/mapper/cryptroot /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot


#find best packman mirrors
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
cat > /etc/pacman.d/mirrorlist <<EOL
Server = http://mirrors.xmission.com/archlinux/\$repo/os/\$arch
Server = http://mirrors.gigenet.com/archlinux/\$repo/os/\$arch
Server = http://mirror.nexcess.net/archlinux/\$repo/os/\$arch
Server = http://mirror.us.leaseweb.net/archlinux/\$repo/os/\$arch
Server = http://mirror.umd.edu/archlinux/\$repo/os/\$arch
Server = http://mirror.jmu.edu/pub/archlinux/\$repo/os/\$arch
EOL

#install base system
pacstrap /mnt base base-devel

#install bootloader
arch-chroot /mnt pacman -S --noconfirm grub-bios

#generate fstab
genfstab -p /mnt >> /mnt/etc/fstab

#prepare next script
mv ./arch2.sh /mnt/root/arch2.sh
arch-chroot /mnt chmod +x /root/arch2.sh
arch-chroot /mnt /bin/bash /root/arch2.sh

umount /mnt/boot
umount /mnt

