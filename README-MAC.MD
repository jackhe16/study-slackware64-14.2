# Study Slackware64-14.2
> official: <http://www.slackware.com/>
>
> mirror: <https://hkg.mirror.rackspace.com/slackware/slackware64-14.2>
> 
> tuntaposx

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
mount_cd9660 /dev/disk2 ~/mnt/iso
cp -r ~/mnt/iso slackware64-14.2
```

> Unmount
```sh
umount /dev/disk2
hdiutil detach /dev/disk2
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
qemu-system-x86_64 -m 4096 -boot order=c -hda slackware64-14.2.cow2 -hdb fat:rw:tmp/mnt
```

```sh
qemu-system-x86_64 -name slackware64-14.2 -m 4096 -boot order=c -hda slackware64-14.2.cow2 -hdb fat:rw:tmp/mnt \
    -M accel=hvf -vga std \
    -netdev user,id=n1,ipv6=off,hostfwd=tcp::2222-:22 \
    -device e1000,netdev=n1,mac=52:54:98:76:54:32

ssh -p 2222 root@localhost
(ssh jackhe16@192.168.1.110)
```

```sh
sudo qemu-system-x86_64 -name slackware64-14.2 -m 4096 -boot order=c -hda slackware64-14.2.cow2 -hdb fat:rw:tmp/mnt \
    -M accel=hvf -vga std \
    -netdev tap,id=mynet0,ifname=tap0,script=no,downscript=no \
    -device e1000,netdev=mynet0,mac=52:54:98:76:54:32

sudo ifconfig tap0 10.0.2.3 netmask 255.255.255.0 up

ssh root@10.0.2.15
(ssh jackhe16@10.0.2.3)
```

## Start sshd
```bash
sudo launchctl unload /System/Library/LaunchDaemons/ssh.plist
sudo launchctl load -w /System/Library/LaunchDaemons/ssh.plist
```

## Learn Source Code
