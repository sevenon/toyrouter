#!/bin/sh

echo "content-type:  text/plain"
echo ""
echo "Toyrouter"
echo ""
echo "System date: `date`"
echo
echo "Network:"
ip addr | cat
echo
echo "DHCP leases:"
dumpleases | cat
echo 
echo "Firewall:"
iptables-save | cat
echo
echo Last 200 lines of system log:
tail -n 200 /var/log/messages

