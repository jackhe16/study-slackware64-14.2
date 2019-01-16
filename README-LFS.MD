# LFS

```bash
qemu-img create -f qcow2 lfs.cow2 64G

qemu-system-x86_64 -name slackware64-14.2 -m 4096 -boot order=c -hda slackware64-14.2.cow2 -hdb lfs.cow2 \
    -M accel=hvf -vga std \
    -netdev user,id=n1,ipv6=off,hostfwd=tcp::2222-:22 \
    -device e1000,netdev=n1,mac=52:54:98:76:54:32

ssh -p 2222 root@localhost
(ssh jackhe16@192.168.1.110)
```