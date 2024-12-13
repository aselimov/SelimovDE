#!/bin/bash
# Check to see if openvpn is running. If it is then output a message

pgrep openvpn 1>/dev/null &&
    echo "	VPN ACTIVATED"
