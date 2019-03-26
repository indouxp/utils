#!/bin/sh
###############################################################################
#
# monitorix$B$N(BWeb$B2hLL$r!"(Bobs600d$B$X$N(Bssh$B<B9T$K$h$j!"%]!<%H%U%)%o!<%G%#%s%0$9$k!#(B
#
###############################################################################
name=${0##*/}

if [ "$#" -eq "0" ]; then
  cat <<EOT
Usage
\$ ${name:?} monitorix localport
  monitorix: monitorix hostname or monitorix ip address
  localport: 
ex)
  \$ ${name:?} rpi3-2 10011
  Enter passphrase for key '/home/indou/.ssh/id_rsa':
  Enter passphrase for key '/home/indou/.ssh/id_rsa':
  ^Z
  [1]+  $BDd;_(B                  ./monitorix.sh rpi3-2 10011
  \$ bg
  [1]+ ./monitorix.sh rpi3-2 10011 &
  \$ jobs
  [1]+  $B<B9TCf(B               ./monitorix.sh rpi3-2 10011 &
  \$ kill %1
  \$ jobs
  [1]+  Terminated              ./monitorix.sh rpi3-2 10011
  \$
EOT
  exit 0
fi

monitorix=$1
localport=$2

ssh -4 -L ${localport:?}:${monitorix:?}:8080 -N ${monitorix:?}
