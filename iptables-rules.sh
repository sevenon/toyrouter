#!/bin/sh

# clear existing rules
iptables -t filter -F
iptables -t nat -F

# route between lan and wan, translate ip addresses
iptables -t nat -A POSTROUTING -o wan0 -j MASQUERADE

# disable access to router from wan (ftp, telnet, http)
iptables -t filter -A INPUT -i wan0 -p tcp --dport 20:80 -j REJECT

# allow routing from wan only if connection has been established from lan
# also accept port forwards from prerouting (DNAT)
# standard setting on most routers but may not be essential with MASQUERADE and selective port forward
# iptables -t filter -A FORWARD -i wan0 -m conntrack ! --ctstate RELATED,ESTABLISHED,DNAT -j REJECT

# port forward example
# iptables -t nat -A PREROUTING -i wan0 -p tcp --dport 80 -j DNAT --to 192.168.88.102:8080

# time based restriction example
# -I to insert before conntrack rule
# iptables -t filter -I FORWARD -p all -s 192.168.88.101 -m time --timestart 20:00:00 --timestop 23:59:59 --weekdays Mon --kerneltz -j REJECT

# example to redirect all dns to opendns nameserver - test with dnsleaktest.com
# iptables -t nat -A PREROUTING -i lan0 -p udp --dport 53 -j DNAT --to 208.67.222.222:53

