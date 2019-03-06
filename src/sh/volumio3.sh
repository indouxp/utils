#!/bin/sh
###############################################################################
#
# volumioのリモート実行
#
###############################################################################
NAME=${0##*/}
LOG_DIR=/home/${USER:?}/log
LOG_PATH=$LOG_DIR/${NAME:?}.log

date                            >> ${LOG_PATH:?}
if [ ! -x $(which curl) ]; then
  echo "${NAME:?}: curl not found." | tee -a ${LOG_PATH:?}
fi
if [ ! -x $(which jq) ]; then
  echo "${NAME:?}: jq not found." | tee -a ${LOG_PATH:?}
fi

PLAYLIST=$1
VOL=$2
echo "PLAYLIST: ${PLAYLIST:?}"  >> ${LOG_PATH:?}
echo "VOLUME  : ${VOL:?}"       >> ${LOG_PATH:?}

curl "http://localhost:3000/api/v1/commands?cmd=playplaylist&name=${PLAYLIST:?}" \
  >> ${LOG_PATH:?} 2>&1                                      |\
  jq '.response' >> ${LOG_PATH:?}

curl "http://localhost:3000/api/v1/commands?cmd=volume&volume=${VOL:?}" \
  >> ${LOG_PATH:?} 2>&1                                      |\
  jq '.response' >> ${LOG_PATH:?}
