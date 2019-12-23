#!/usr/bin/env bash
################################################################################
# Filename: ArchInstallation2.sh
# Date Created: 21-dec-19
# Date last update: 21-dec-19
# Author: Marco Tijbout
#
# Version 0.1
#
# Enhancement ideas:
#   - 
#
# Version history:
# 0.1  Marco Tijbout:
#   Initial release of the script.
################################################################################

################################################################################
## CHROOT - INSTALLATION
################################################################################
TARGET_MACHINE=archvm

# Set the locale for the system:
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen

# Generate the locales:
locale-gen

# Configure what language to use:
echo "LANG=en_US.UTF-8" >> /etc/locale.conf

# Set time zone to Europe Amsterdam:
ln -sf /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime

# Set the time standard to UTC using command:
hwclock --systohc --utc

# Set the hostname
echo "$TARGET_MACHINE" >> /etc/hostname

# Fill the hosts file:
cat <<EOI > /etc/hosts
127.0.0.1    localhost
::1          localhost
127.0.1.1    $TARGET_MACHINE.localdomain     $TARGET_MACHINE
EOI

# Install and enable netowrkmanager:
pacman -S --noconfirm networkmanager
systemctl enable NetworkManager

# Install and enable OpenSSH
pacman -S --noconfirm openssh
systemctl enable sshd

# Install the bootloader
pacman -S --noconfirm grub efibootmgr
grub-install --target=x86_64-efi --efi-directory=/boot
grub-mkconfig -o /boot/grub/grub.cfg

echo -e "\n * Set password for root ...\n"
echo -e "theiotcloud\ntheiotcloud" | passwd

# Exit this part of the script
exit