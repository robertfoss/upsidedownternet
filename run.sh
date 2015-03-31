#!/bin/bash


ifdown wlan1
ifup wlan1

sleep 2

echo "1" > /proc/sys/net/ipv4/ip_dynaddr
echo "1" > /proc/sys/net/ipv4/ip_forward

iptables-restore < /opt/iptables.rules  && \
udhcpd /opt/udhcpd.conf                 && \
hostapd -B /opt/hostapd.conf            && \
/etc/init.d/nginx start                 && \
squid3 -N -f /opt/squid.conf


exit 0
