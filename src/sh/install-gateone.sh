#!/bin/sh
###############################################################################
#  
# 
###############################################################################

TERM() {
  set +o errexit
}

trap 'TERM' 0

set -o errexit

wget https://github.com/downloads/liftoff/GateOne/gateone_1.1-1_all.deb

wget https://github.com/downloads/liftoff/GateOne/python-tornado_2.4-1_all.deb

sudo dpkg -i python-tornado_2.4-1_all.deb

sudo dpkg -i gateone_1.1-1_all.deb

sudo systemctl start gateone
