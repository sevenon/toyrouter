#!/bin/sh

# enable forwarding between network interfaces
echo 1 > /proc/sys/net/ipv4/ip_forward

# clear existing rules
iptables -t filter -F
iptables -t nat -F

# route between lan and wan, translate ip addresses
iptables -t nat -A POSTROUTING -o wan0 -j MASQUERADE

# allow all connections from lan to wan
iptables -t filter -A FORWARD -i lan0 -o wan0 -j ACCEPT

# only allow established connections from wan
iptables -t filter -A FORWARD -i wan0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT

# no other forwarding between lan and wan
iptables -t filter -A FORWARD -j REJECT

# disable access to router from wan (ftp, ssh, telnet, http)
# iptables -t filter -A INPUT -i wan0 -p tcp --dport 20:80 -j REJECT



# port forward - tested
# iptables -t nat -A PREROUTING -i wan0 -p tcp --dport 80 -j DNAT --to 192.168.88.102:12969
# iptables -t filter -I FORWARD -p tcp -d 192.168.88.102 --dport 12969 -j ACCEPT

# time based restriction - tested
# iptables -t filter -I FORWARD -p all -s 192.168.88.101 -m time --timestart 20:00:00 --timestop 23:59:59 --weekdays Mon --kerneltz -j REJECT

# dns force to open dns
# test with dnsleaktest.com
# iptables -t nat -I PREROUTING -i lan0 -p udp --dport 53 -j DNAT --to 208.67.222.222:53
