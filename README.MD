# Study Slackware64-14.2
> official: <http://www.slackware.com/>
>
> mirror: <https://hkg.mirror.rackspace.com/slackware/slackware64-14.2>

## Download ISO
```sh
wget https://hkg.mirror.rackspace.com/slackware/slackware-iso/slackware64-14.2-iso/slackware64-14.2-install-dvd.iso
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

## Installer
```sh
qemu-system-x86_64 -boot order=d -cdrom slackware64-14.2-install-dvd.iso -m 512
```

## Learn Source Code