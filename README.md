## chroot

This command may be used directly as root, but normal users are not able to use this command. 

## schroot

schroot allows access to chroots for normal users using the same mechanism, but with permissions checking and allowing additional automated setup of the chroot environment, such as mounting additional filesystems and other configuration tasks.

## dchroot

dchroot is and earlier version and is being deprecated in favour of schroot.

## arch-chroot 

arch-chroot is a shell script that prepares a new "root directory" with the necessary system mounts (/proc, /sys, /dev, etc.) and files (/etc/resolv.conf), then does a chroot into it. Once you exit from the environment system mounts (mounted before) are unmounted automaticaly.

Instal on Ubuntu with: 

	sudo apt install arch-install-scripts

## QEMU 

QEMU is a processor emulator knows as Hypervisor of type 2.
It has two operating modes:
- User mode emulation: QEMU can launch Linux processes compiled for one CPU on another CPU, translating syscalls on the fly.
- Full system emulation: QEMU emulates a full system (virtual machine), including a processor and various peripherals such as disk, ethernet controller etc.

### User mode emulation

In summary, user mode emulation is a nice mode when it works and should be preferred when speed matters, but is not a perfect astraction. e.g. This mode does not cover all syscalls.
Full system emulation mode should be used for a more complete emulation.

#### TODO: Full System emulation
https://www.cnblogs.com/pengdonglin137/p/5020143.html

### debootstrap vs qemu-debootstrap

qemu-deboostrap is just like debootstrap, but copies a static qemu interpreter in the chroot as well.

Usage:  sudo qemu-debootstrap --arch=<target-arch> <target-distro> <path-to-directory>

### Known Issues

ISSUE 1:
In the User mode emulation QEMU does not cover all syscalls so it might result in the debug output like:

        qemu: Unsupported syscall: 335

ISSUE 2:
The error message sudo: no tty present and no askpass program specified will occur when the sudo command is trying to execute a command that requires a password but sudo does not have access to a tty to prompt the user for a passphrase. As it can’t find a tty, sudo fall back to an askpass method but can’t find an askpass command configured.

        sudo: no tty present and no askpass program specified

