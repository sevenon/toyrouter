#!/bin/sh

logger "$0 $1 : " `env`

case "$1" in
	deconfig)
		ifconfig $interface 0.0.0.0
		;;

	renew|bound)
		netmask=""
		[ -n "$subnet" ] && netmask="netmask $subnet"
		broadcast_arg="broadcast +"
		[ -n "$broadcast" ] && broadcast_arg="broadcast $broadcast"
		ifconfig $interface $ip $netmask $broadcast_arg

		gateway=`echo $router | cut -d' ' -f1`
		if [ -n "$gateway" ] ; then
			route del default gw 0.0.0.0 dev $interface
			route add default gw $gateway dev $interface
		fi

		[ -f /var/run/ddns-updater.sh.pid ] && kill `cat /var/run/ddns-updater.sh.pid`
		;;
esac

exit 0
