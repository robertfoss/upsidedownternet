#!/bin/bash

# Build docker image
docker build -t upsidedownternet .

# Remove interface from network manager control
if test -f "/etc/init.d/network-manager"; then
    if test -f "/etc/init.d/network-manager"; then
        rfkill unblock wlan
        grep "iface wlan1 inet manual" /etc/network/interfaces || echo "iface wlan1 inet manual" >> /etc/network/interfaces;
        /etc/init.d/network-manager force-reload;
    fi
fi
ifdown wlan1
ip addr flush dev wlan1


# Run docker image
docker run --privileged -it --net=host upsidedownternet:latest
