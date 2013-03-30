#!/bin/sh
###############################################################################
# /etc/sysconfig/network-scripts/ifcfg-eh?
#
###############################################################################
if [ "$#" -eq "0" ]; then
  echo -n "DEVICE:"
  read DEVICE
  echo -n "IPADDR:"
  read IPADDR
  echo -n "NETMASK:"
  read NETMASK
  echo -n "BROADCAST:"
  read BROADCAST
else
  DEVICE=$1
  IPADDR=$2
  NETMASK=$3
  BROADCAST=$4
fi


  cat <<EOT
/etc/sysconfig/network-scripts/ifcfg-${DEVICE:?}
----------------------------
DEVICE="${DEVICE:?}"
ONBOOT="yes"
BOOTPROTO="static"
IPADDR="${IPADDR:?}"
NETMASK="${NETMASK:?}"
BROADCAST="${BROADCAST:?}"
EOT
