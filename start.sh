#!/bin/bash

# IP lists for IOCS (blank if get_ioc_ips.py fails)
export IPS="$(python3 /get_ioc_ips.py)"
export EPICS_PVA_ADDR_LIST=${IPS:-127.0.0.1}
export EPICS_CA_ADDR_LIST=${IPS:-127.0.0.1}

# PORTS for CA and PVA
export EPICS_CA_SERVER_PORT=${EPICS_CA_SERVER_PORT:-5064}
export EPICS_PVA_SERVER_PORT=${EPICS_PVA_SERVER_PORT:-5075}

# DEBUGGING
CA_DEBUG=${CA_DEBUG:-0}
PVA_DEBUG=${PVA_DEBUG:-0}

# background the CA Gateway
/epics/ca-gateway/bin/linux-x86_64/gateway -sport ${EPICS_CA_SERVER_PORT:-5064} -cip "${EPICS_CA_ADDR_LIST}" -pvlist /config/pvlist -access /config/access -log /dev/stdout -debug ${CA_DEBUG:-0} &>/tmp/cagw.log &

# fix up the templated pva gateway config
cat /config/pvagw.template |
  sed \
    -e "s/EPICS_PVA_ADDR_LIST/${EPICS_PVA_ADDR_LIST}/" \
    -e "s/EPICS_PVA_SERVER_PORT/${EPICS_PVA_SERVER_PORT}/" \
    > /config/pvagw.config

# background the PVA Gateway
pvagw /config/pvagw.config &>/tmp/pvagw.log &

# Start an interactive shell for debugging
bash