# Make A Bootable HardDisk

> tools: grub2, 

## Prepare HardDisk
```bash
mkdir hd-linux
cd hd-linux
dd if=/dev/zero of=hd-disk.img bs=1M count=64
fdisk hd-disk.img -> n, w, q
losetup -o 1048576 /dev/loop0 hd-disk.img
mkfs.ext3 /dev/loop0
```

## Install Grub2
```bash
mount -t ext3 /dev/loop0 /mnt/hd/
mkdir /mnt/hd/boot
grub-install --boot-directory=/mnt/hd/boot/ --target=i386-pc --modules=part_msdos hd-disk.img
```

## Compile Linux Kernel
```bash
make clean
make prepare
make x86_64_defconfig
make bzImage -j4
cp arch/x86/boot/bzImage /mnt/hd/boot/
```

## Make Initrd
```bash
mkinitrd -o /mnt/hd/boot/initrd.gz
```

## Grub Config
```bash
cat > /mnt/hd/boot/grub/grub.cfg << EOF
menuentry "FreshLinux" {
    linux (hd0,1)/boot/bzImage console=tty0
    initrd (hd0,1)/boot/initrd.gz
}
EOF
```

## Umount
```bash
umount /mnt/hd/
losetup -d /dev/loop0
```

## Start
```bash
qemu-system-x86_64 -hda hd-disk.img
```