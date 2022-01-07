#!/bin/bash

if [[ $EUID -ne 0 ]]; then
   echo "This script requires root, run it again with sudo" 
   exit 1
fi

LOOPDEV=$(losetup -P -f --show ${1})

mkdir -p /mnt/rpi-image/

# mount partition
mount -o rw ${LOOPDEV}p2  /mnt/rpi-image
mount -o rw ${LOOPDEV}p1 /mnt/rpi-image/boot

# mount binds
mount --bind /dev /mnt/rpi-image/dev/
mount --bind /sys /mnt/rpi-image/sys/
mount --bind /proc /mnt/rpi-image/proc/
mount --bind /dev/pts /mnt/rpi-image/dev/pts
mount --bind /run /mnt/rpi-image/run

# We need to comment out the copies and fills preload
# because we may be running on a machine/emulator that doesn't
# supoort the specical instructions that are used
sed -i 's/^/#QEMU /g' /mnt/rpi-image/etc/ld.so.preload

# copy qemu binary
cp /usr/bin/qemu-arm-static /mnt/rpi-image/usr/bin/

# chroot to rpi-image
chroot /mnt/rpi-image /bin/bash

# -------------------------- ON EXIT ---------------------------- #
# Clean up
# revert ld.so.preload fix
sed -i 's/^#QEMU //g' /mnt/rpi-image/etc/ld.so.preload

# unmount everything
umount -lf /mnt/rpi-image/{dev/pts,dev,sys,proc,boot,run}
umount -lf /mnt/rpi-image



# KNOWN ISSUES
#
# 1	sudo: no tty present and no askpass program specified

# Explanation: The error message sudo: no tty present and no askpass program specified will occur 
# 	       when the sudo command is trying to execute a command that requires a password 
#	       but sudo does not have access to a tty to prompt the user for a passphrase. 
#	       As it can’t find a tty, sudo fall back to an askpass method but can’t find an 
#	       askpass command configured.
#
# Solution: Execute a command with sudo and no password requirements
#
# This is by adding to /etc/sudoers:
#
#	%admin  ALL=(ALL) NOPASSWD:ALL


