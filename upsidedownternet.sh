#!/bin/bash

AP_INTERFACE=$1
AP_INTERFACE_MAC=$(cat "/sys/class/net/$AP_INTERFACE/address")

# Build docker image
docker build -t upsidedownternet .

# Remove interface from network manager control
if test -f "/etc/init.d/network-manager"; then
    if test -f "/etc/NetworkManager/NetworkManager.conf"; then
        /etc/init.d/network-manager stop > /dev/null 2>&1
        killall wpa_supplicant > /dev/null 2>&1
        
        # Prevent network manager from managing interface
        (grep "iface $AP_INTERFACE inet manual" /etc/network/interfaces || echo "iface $AP_INTERFACE inet manual" >> /etc/network/interfaces) > /dev/null 2>&1
        
        # Prevent wpa_supplicant from grabbing out interface
        grep "\[keyfile\]" /etc/NetworkManager/NetworkManager.conf || \
        (
            (echo "" >> /etc/NetworkManager/NetworkManager.conf) > /dev/null 2>&1
            (echo "[keyfile]" >> /etc/NetworkManager/NetworkManager.conf) > /dev/null 2>&1
            (echo "unmanaged-devices=mac:$AP_INTERFACE_MAC" >> /etc/NetworkManager/NetworkManager.conf) > /dev/null 2>&1
        );
        /etc/init.d/network-manager start > /dev/null 2>&1
    fi
fi
ifdown $AP_INTERFACE > /dev/null 2>&1
ip addr flush dev $AP_INTERFACE > /dev/null 2>&1


# Run docker image
docker run \
    -it \
    --privileged \
    --net=host \
    -e AP_INTERFACE=$AP_INTERFACE \
    upsidedownternet:latest
