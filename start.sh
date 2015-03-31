#!/bin/bash

if [ -n "${AP_INTERFACE+1}" ]; then
    find /opt/ -type f -exec sed -i -e "s/wlan1/${AP_INTERFACE}/g" {} \;
fi

/opt/run.sh


exit 0
