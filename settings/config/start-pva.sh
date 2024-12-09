#!/bin/bash

# IP lists for IOCS (blank if get_ioc_ips.py fails)
export IPS="$(python3 /config/get_ioc_ips.py)"
export EPICS_PVA_ADDR_LIST=${IPS:-127.0.0.1}
export EPICS_CA_ADDR_LIST=${IPS:-127.0.0.1}

# PORTS for CA and PVA
export CA_SERVER_PORT=${CA_SERVER_PORT:-5064}
export PVA_SERVER_PORT=${PVA_SERVER_PORT:-5075}

# DEBUGGING
CA_DEBUG=${CA_DEBUG:-0}
PVA_DEBUG=${PVA_DEBUG:-0}

# fix up the templated pva gateway config
cat /config/pvagw.template |
  sed \
    -e "s/PVA_ADDR_LIST/${EPICS_PVA_ADDR_LIST}/" \
    -e "s/PVA_SERVER_PORT/${PVA_SERVER_PORT}/" \
    > /tmp/pvagw.config

# background the PVA Gateway
pvagw /tmp/pvagw.config
