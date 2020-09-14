#!/bin/sh

interface=$1
updown=$2

logger "$0 : $interface $updown"

case $updown in
    up)
        kill `cat /var/run/udhcpc.pid`
    ;;
    down)
        ifconfig $interface 0.0.0.0 down
    ;;
esac

exit 0