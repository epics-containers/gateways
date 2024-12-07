#!/bin/bash

IP_LIST=$(python3 /get_ioc_ips.py))

ca_args="
-sport ${CA_PORT:-5064}
-cip ${IP_LIST}
-pvlist /config/pvlist
-access /config/access
-log /dev/stdout
-debug ${CA_DEBUG:-0}
"

# background the CA Gateway
/epics/ca-gateway/bin/linux-x86_64/gateway "${ca_args}" &

# Start an interactive shell for debugging
bash