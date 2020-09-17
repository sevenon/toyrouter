#!/bin/sh

ip_address=$(cat /etc/udhcpd.conf | grep -m 1 '^option[[:space:]]\+router' | awk '{print $3}')
subnet=$(cat /etc/udhcpd.conf | grep -m 1 '^option[[:space:]]\+subnet' | awk '{print $3}')

logger "Configuring lan0 with address $ip_address netmask $subnet"

ifconfig lan0 $ip_address netmask $subnet
