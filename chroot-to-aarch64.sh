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
#sed -i 's/^/#QEMU /g' /mnt/rpi-image/etc/ld.so.preload

# copy qemu binary
cp /usr/bin/qemu-aarch64-static /mnt/rpi-image/usr/bin/

# chroot to rpi-image
chroot /mnt/rpi-image /bin/bash

# -------------------------- ON EXIT ---------------------------- #
# Clean up
# revert ld.so.preload fix
#sed -i 's/^#QEMU //g' /mnt/rpi-image/etc/ld.so.preload

# unmount everything
umount -lf /mnt/rpi-image/{dev/pts,dev,sys,proc,boot,run}
umount -lf /mnt/rpi-image
