# Make A Bootable Hard Disk With LiLo

> <https://www.tldp.org/HOWTO/Hard-Disk-Upgrade/index.html>

## Prepare Disk Image
```bash
mkdir lilo-linux
cd lilo-linux
dd if=/dev/zero of=lilo-linux.img bs=1M count=64
cp ../../slackware64-14.2/kernels/huge.s/bzImage ./
cp ../../slackware64-14.2/isolinux/initrd.img ./
```

## Running Slackware, Mount lilo-linux.img as /dev/sdb
```bash
qemu-system-x86_64 -name slackware64-14.2 -m 4096 -boot order=c \
-hda ../../slackware64-14.2.cow2 -hdb ../../tutorial/lilo-linux/lilo-linux.img -hdc fat:rw:../../tutorial/lilo-linux \
-M accel=hvf -vga std -netdev user,id=n1,ipv6=off -device e1000,netdev=n1,mac=52:54:98:76:54:32

fdisk /dev/sdb -> n, w, q
mkfs.ext2 /dev/sdb1
mkdir /new-disk/
mount /dev/sdb1 /new-disk/
cd /new-disk
mkdir {boot,etc}

mount /dev/sdc1 /mnt/hd/
cp /mnt/hd/bzImage boot/
cp /mnt/hd/initrd.img ./
umount /mnt/hd/
```

## LiLo Configure
```bash
cat > etc/lilo.conf << EOF
disk = /dev/sdb bios = 0x80
boot = /dev/sdb
map = /new-disk/boot/map
install = /new-disk/boot/boot.b

prompt
timeout = 50

image = /new-disk/boot/bzImage
  label = linux
  initrd = /new-disk/initrd.img
  root = /dev/sda1
  read-only
EOF
```

## LiLo Install
```bash
/sbin/lilo -C /new-disk/etc/lilo.conf
```

## Umount And Exit Qemu
```bash
cd /
umount /new-disk
poweroff
```

## Runnig lilo-linux.img In Qemu
```bash
qemu-system-x86_64 -m 1024 -boot order=c -hda lilo-linux.img 
```

## Modify LILO configuration file
```bash
cat > /etc/lilo.conf << EOF
boot = /dev/sda

map = /boot/map
install = /boot/boot.b

prompt
timeout = 50

image = /boot/bzImage
  label = linux
  root = /dev/sda1
  read-only
EOF
```