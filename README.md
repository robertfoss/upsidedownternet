# upsidedownternet
A dockerized wifi access point with upsidedownternet functionality.

# Supported hosts
 * Ubuntu with network manager
 * Linux distros with unmanaged network

These restrictions are based around the fact that hostapd running in the docker container needs full access to an unused wlan interface. If the interface is used by _any_ other process, hostapd will be unable to initialize it.

# Run
wlan1 = your access point capable wifi-interface of choice
    sudo ./upsidedownternet.sh wlan1
