#!/bin/sh
################################################################################
#
# rdesktopで、接続
#
################################################################################
NAME=${0##*/}
if [ "$#" -eq "0" ]; then
  cat <<EOT
Usage
\$ ${NAME:?} HOST USER 
EOT
  exit 0
fi

HOST=$1
USER=$2

rdesktop -g 1280x720 -r clipboard:CLIPBOARD -u ${USER:?} ${HOST:?}
#rdesktop -g 1152x640 -r clipboard:CLIPBOARD -u ${USER:?} ${HOST:?}
exit $?
