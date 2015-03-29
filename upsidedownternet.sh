#!/bin/bash

IF_MAC=$(cat /sys/class/net/wlan1/address)

# Build docker image
docker build -t upsidedownternet .

# Remove interface from network manager control
if test -f "/etc/init.d/network-manager"; then
    if test -f "/etc/init.d/network-manager"; then
        /etc/init.d/network-manager stop
        killall wpa_supplicant
        
        # Prevent network manager from managing interface
        grep "iface wlan1 inet manual" /etc/network/interfaces || echo "iface wlan1 inet manual" >> /etc/network/interfaces;
        
        # Prevent wpa_supplicant from grabbing out interface
        grep "\[keyfile\]" /etc/NetworkManager/NetworkManager.conf || \
        (
         echo "" >> /etc/NetworkManager/NetworkManager.conf
         echo "[keyfile]" >> /etc/NetworkManager/NetworkManager.conf
         echo "unmanaged-devices=mac:$IF_MAC" >> /etc/NetworkManager/NetworkManager.conf
        );
        /etc/init.d/network-manager start;
    fi
fi
ifdown wlan1
ip addr flush dev wlan1


# Run docker image
docker run --privileged -it --net=host upsidedownternet:latest
