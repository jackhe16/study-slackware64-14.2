#!/bin/bash
echo "Executing /etc/qemu-ifup"
echo "Creating bridge"
sysctl -w net.link.ether.inet.proxyall=1
sysctl -w net.inet.ip.forwarding=1
sysctl -w net.inet.ip.fw.enable=1
ifconfig bridge0 create
echo "Bringing up $1 for bridged mode"
#Get the number of interface
num=`echo $1 | sed 's/tap//'`
ifconfig $1 192.168.2.1$num up
echo "Add $1 to bridge"
ifconfig bridge0 addm en1 addm $1
echo "Bring up bridge"
ifconfig bridge0 up
echo "Starting Natd on en1"
natd -interface en1
echo "Writing ipfw rule"
ipfw add divert natd ip from any to any via en1