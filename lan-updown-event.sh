#!/bin/sh
# lan-updown-event.sh

interface=$1
updown=$2

logger "$0 : $interface $updown"

case $updown in
    up)
        ip=$(cat /etc/udhcpd.conf | grep -m 1 '^option[[:space:]]\+router' | awk '{print $3}')
        subnet=$(cat /etc/udhcpd.conf | grep -m 1 '^option[[:space:]]\+subnet' | awk '{print $3}')
        logger "$0 : ifconfig $interface $ip netmask $subnet up"
        ifconfig $interface $ip netmask $subnet up
        ;;

    down)
        ifconfig $interface 0.0.0.0 down
        ;;
esac

exit 0
