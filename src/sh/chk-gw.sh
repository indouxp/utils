#!/bin/sh
###############################################################################
#
# default gatwayに、pingし、途絶えている場合は、networkを再起動します。
#
###############################################################################
SCRIPT_DIR=${0%/*}
SCRIPT_NAME=$0##*/}

NOT_DIR=/var/log
NOT_NAME=${0##*/}.number_of_time
NOT_PATH=${NOT_DIR:?}/${NOT_NAME:?}

LOG_DIR=/var/log
LOG_NAME=${0##*/}.log
LOG_PATH=${LOG_DIR:?}/${LOG_NAME:?}

INIT_NAME=init-${0##*/}
cat <<EOT > ${SCRIPT_DIR:?}/${INIT_NAME:?}
#!/bin/sh
###############################################################################
#
# /etc/rc.localより呼び出され、${NOT_PATH}を削除します。
#
###############################################################################
cat /dev/null > ${NOT_PATH:?}
EOT

###############################################################################
GW=""
GW=`LANG=C route | awk 'match($1, /default/) {print $2}'`
if [ "${GW:?}" = "" ]; then
  echo "${SCRIPT_NAME:?}:GW fail." | tee -a ${LOG_PATH:?} 1>&2
  exit 1
fi

###############################################################################
ping -c1 ${GW:?}
RC=$?
if [ "${RC:?}" -ne "0" ];then
  echo "${SCRIPT_NAME:?}:ping fail." | tee -a ${LOG_PATH:?} 1>&2
  service networking restart | tee -a ${LOG_PATH:?} 2>&1
fi
exit 0
