#!/bin/sh

inst=/usr/local/toyrouter

# make sure user root is running this
[ "`whoami`" != "root" ] && echo "run uninstall script as root" && exit 1

rm -fr $inst
rm -f /etc/grub.d/15_toyrouter
rm -f /etc/default/grub.d/toyrouter-grub.cfg

echo "run update-grub to restore the boot menu"
