#!/bin/sh
###############################################################################
#
# REFERENCE:https://ja.opensuse.org/openSUSE:UEFI#.E3.83.96.E3.83.BC.E3.83.88.E3.83.9E.E3.83.8D.E3.83.BC.E3.82.B8.E3.83.A3
#
###############################################################################

od -An -t u1 /sys/firmware/efi/vars/SecureBoot-*/data
od -An -t u1 /sys/firmware/efi/vars/SecureBoot-8be4df61-93ca-11d2-aa0d-00e098032b8c/data

