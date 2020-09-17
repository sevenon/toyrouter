#!/bin/sh -v

# remount root as read write
mount -o remount, rw /

# load usb ethernet kernel module
# modprobe asix

# rename network interfaces to lan0 and wan0
ip link set eth0 down
ip link set eth1 down
ip link set eth0 name wan0
ip link set eth1 name lan0

# overlay Toyrouter over Ubuntu
inst=/usr/local/toyrouter
work=/var/toyrouter-overlay-workdir

rm -fr $work
mkdir -p $work/bin
mkdir -p $work/sbin
mkdir -p $work/etc

/usr/bin/mount -t overlay -o lowerdir=/etc,upperdir=$inst/etc,workdir=$work/etc none /etc
/usr/bin/mount -t overlay -o lowerdir=/usr/sbin,upperdir=$inst/sbin,workdir=$work/sbin none /usr/sbin
/usr/bin/mount -t overlay -o lowerdir=/usr/bin,upperdir=$inst/bin,workdir=$work/bin  none /usr/bin

# hand over to busybox init
exec /bin/init
