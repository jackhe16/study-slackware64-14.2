# Make A Bootable ISO File

> tools: syslinux(isolinux), cdrtools(mkisofs)

## Prepare
```bash
mkdir CD_slack
cd CD_slack
mkdir {isolinux,kernels}
cp ../../slackware64-14.2/isolinux/isolinux.bin isolinux/
cp ../../slackware64-14.2/isolinux/initrd.img isolinux/
cp ../../slackware64-14.2/kernels/huge.s/bzImage kernels/
cat > isolinux/isolinux.cfg << EOF
default Slack
prompt 1
timeout 1200
display boot.txt
label Slack
  kernel /kernels/bzImage
  append initrd=initrd.img
EOF
cat > isolinux/boot.txt << EOF

Welcome to Slack!

EOF
```

## Make Bootable ISO
```bash
mkisofs -o ../slack.iso \
   -b isolinux/isolinux.bin -c isolinux/boot.cat \
   -no-emul-boot -boot-load-size 4 -boot-info-table \
   .
```

## Run In Qemu
```bash
cd ..
qemu-system-x86_64 -boot d -cdrom slack.iso -m 1024
```