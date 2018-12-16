# Study Slackware64-14.2
> official: <http://www.slackware.com/>
>
> mirror: <https://hkg.mirror.rackspace.com/slackware/slackware64-14.2>

## Download ISO
```sh
wget https://hkg.mirror.rackspace.com/slackware/slackware-iso/slackware64-14.2-iso/slackware64-14.2-install-dvd.iso
```
### Extract ISO files(Mac)
> Mount
```sh
mkdir -p ~/mnt/iso
hdiutil attach -nomount slackware64-14.2-install-dvd.iso
diskutil list
mount_iso9660 /dev/disk5 ~/mnt/iso
cp -r ~/mnt/iso slackware64-14.2
```
> Unmount
```sh
umount /dev/disk5
hdiutil detach /dev/disk5
```

## Download Source(optional)
```sh
./scripts/download_source.sh
```

## Download Slackbuild(optional)
> [slackbuilds.org](http://slackbuilds.org/)
```sh
wget https://git.slackbuilds.org/slackbuilds/snapshot/slackbuilds-14.2-20181020.1.tar.gz
```

## Create disk image
```sh
qemu-img create -f qcow2 slackware64-14.2.cow2 64G
```

## Installer
```sh
qemu-system-x86_64 -boot order=d -cdrom slackware64-14.2-install-dvd.iso -hda slackware64-14.2.cow2 -m 1024

setup
```

## Boot
```sh
qemu-system-x86_64 -m 4096 -boot order=c -hda slackware64-14.2.cow2 -hdb fat:rw:tmp/release
```
```sh
-net nic -net tap,ifname=tap0,script=no,downscript=no
qemu-system-x86_64 -name slackware64-14.2 -m 4096 -boot order=c -hda slackware64-14.2.cow2 -hdb fat:rw:tmp/release -M accel=hvf -vga std -netdev user,id=n1,ipv6=off -device e1000,netdev=n1,mac=52:54:98:76:54:32
```
## Learn Source Code
