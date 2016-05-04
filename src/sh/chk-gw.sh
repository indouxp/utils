#!/bin/sh
###############################################################################
#
# default gatwayに、pingし、途絶えている場合は、networkを再起動します。
#
###############################################################################
SCRIPT_DIR=${0%/*}
SCRIPT_NAME=${0##*/}

LOG_DIR=/var/log
LOG_NAME=${0##*/}.log
LOG_PATH=${LOG_DIR:?}/${LOG_NAME:?}

###############################################################################
GW=""
GW=`LANG=C route | awk 'match($1, /default/) {print $2}'`
if [ "${GW:?}" = "" ]; then
  echo "${SCRIPT_NAME:?}:GW fail." | tee -a ${LOG_PATH:?} 1>&2
  exit 1
fi
echo "${SCRIPT_NAME:?}:GW:[${GW:?}]." | tee -a ${LOG_PATH:?}

###############################################################################
ping -c1 ${GW:?}
RC=$?
if [ "${RC:?}" -ne "0" ];then
  echo "${SCRIPT_NAME:?}:ping fail." | tee -a ${LOG_PATH:?} 1>&2
  service networking restart | tee -a ${LOG_PATH:?} 2>&1
fi
echo "${SCRIPT_NAME:?}:ping status ${RC:?}." | tee -a ${LOG_PATH:?}

exit 0
