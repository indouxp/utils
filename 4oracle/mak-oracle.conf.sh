#!/bin/sh
# http://www.ajisaba.net/db/ora_linux_install.html
#

set -eu

ldconfig -v > /tmp/${0##*/}.bef

cat <<EOT > /etc/ld.so.conf.d/oracle.conf
/u01/app/oracle/product/11.2.0/xe/lib
EOT

ldconfig

ldconfig -v > /tmp/${0##*/}.aft

diff /tmp/${0##*/}.bef /tmp/${0##*/}.aft
