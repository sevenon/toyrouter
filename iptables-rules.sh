#!/bin/sh

# clear existing rules
iptables -t filter -F
iptables -t nat -F

# route between lan and wan, translate ip addresses
iptables -t nat -A POSTROUTING -o wan0 -j MASQUERADE

# disable access to router from wan (ftp, telnet, http)
iptables -t filter -A INPUT -i wan0 -p tcp --dport 20:80 -j REJECT


# only forward ip from wan if connection has been established from lan
# standard setting on most routers but not essential
# iptables -t filter -A FORWARD -i wan0 -m conntrack ! --ctstate RELATED,ESTABLISHED -j REJECT

# port forward example (second line only required if the above connection tracking rule is enabled)
# iptables -t nat -A PREROUTING -i wan0 -p tcp --dport 80 -j DNAT --to 192.168.88.102:12969
# iptables -t filter -I FORWARD -p tcp -d 192.168.88.102 --dport 12969 -j ACCEPT

# time based restriction example
# iptables -t filter -I FORWARD -p all -s 192.168.88.101 -m time --timestart 20:00:00 --timestop 23:59:59 --weekdays Mon --kerneltz -j REJECT

# example to redirect all dns to opendns nameserver - test with dnsleaktest.com
# iptables -t nat -I PREROUTING -i lan0 -p udp --dport 53 -j DNAT --to 208.67.222.222:53

