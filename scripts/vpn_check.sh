#!/usr/bin/env bash
# Onliner:
# ip -4 addr show tun0 2>/dev/null | awk '/inet / {split($2, a, "/"); print a[1]}' | { read -r ip; echo "VPN: ${ip:-OFF}"; }

IP=$(ip -4 addr show tun0 2>/dev/null \
    | awk '/inet / {print $2}' \
    | cut -d/ -f1)
    
echo "VPN: ${IP:-OFF}"
