# Minimal Linux Script

> busybox, isolinux
>
> busybox build in slacware, mkisofs make iso in mac. mkisofs version in slackware has some trouble..
>
> <https://github.com/ivandavidov/minimal-linux-script>

## Prepare
```bash
mkdir minimal-linux-script
cd minimal-linux-script
mkdir isoimage
cp ../../slackware64-14.2/isolinux/isolinux.bin isoimage/
cp ../../slackware64-14.2/kernels/huge.s/bzImage isoimage/kernel.gz
cp ../../extra-packages/busybox-1.29.3.tar.bz2 ./

tar -jxvf busybox-1.29.3.tar.bz2
cd busybox-1.29.3
make distclean
make defconfig
sed -i "s|.*CONFIG_STATIC.*|CONFIG_STATIC=y|" .config
make busybox
make install
cp -r _install ../rootfs

cd ../rootfs
rm -f linuxrc
mkdir dev proc sys
cat > init << EOF
#!/bin/sh
dmesg -n 1
mount -t devtmpfs none /dev
mount -t proc none /proc
mount -t sysfs none /sys
setsid cttyhack /bin/sh
EOF
chmod +x init
mkdir -p etc/selinux/
cat > etc/selinux/config << EOF
SELINUX=enforcing
EOF
```

## Make rootfs
```bash
find . | cpio -R root:root -H newc -o | gzip > ../isoimage/rootfs.gz
cd ../isoimage
```

## Make ISO
```bash
cat > isolinux.cfg << EOF
default Slack
prompt 1
timeout 1200
display boot.txt
label Slack
  kernel kernel.gz
  append initrd=rootfs.gz
EOF
cat > boot.txt << EOF

Welcome to Slack!

EOF

mkisofs -o ../miniLS.iso \
   -b isolinux/isolinux.bin -c isolinux/boot.cat \
   -no-emul-boot -boot-load-size 4 -boot-info-table \
   .
```

## Run In Qemu
```bash
cd ..
qemu-system-x86_64 -boot d -cdrom miniLS.iso -m 1024
```
