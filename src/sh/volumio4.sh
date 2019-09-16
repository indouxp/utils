#!/bin/sh
###############################################################################
#
# volumioのリモート実行
#
###############################################################################
NAME=${0##*/}
USER=volumio  # cronからだと、未定義
LOG_DIR=/home/${USER:?}/log
LOG_PATH=$LOG_DIR/${NAME:?}.log
PATH=/bin:/usr/bin:/usr/local/bin

echo ${NAME:?}			>> ${LOG_PATH:?}
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

#if curl "http://localhost:3000/api/v1/getState" \
#  >> ${LOG_PATH:?} 2>&1                                     |\
#  jq '.status' | grep "play"
#then
#  echo "Now Playing. Cancel." >> ${LOG_PATH:?}
#  exit 0
#else
#  echo "Now not Playing."     >> ${LOG_PATH:?}
#fi
#
curl "http://localhost:3000/api/v1/commands?cmd=volume&volume=${VOL:?}" \
  >> ${LOG_PATH:?} 2>&1                                      |\
  jq '.response' >> ${LOG_PATH:?}

if curl "http://localhost:3000/api/v1/getState" | jq ".status" | grep "play"; then
  echo ""                >> ${LOG_PATH:?}
  echo "Now Playing..."  >> ${LOG_PATH:?}
  exit 0
else
  echo ""                >> ${LOG_PATH:?}
  echo "No Play"         >> ${LOG_PATH:?}
fi 

curl "http://localhost:3000/api/v1/commands?cmd=playplaylist&name=${PLAYLIST:?}" \
  >> ${LOG_PATH:?} 2>&1                                      |\
  jq '.response' >> ${LOG_PATH:?}

curl "http://localhost:3000/api/v1/commands?cmd=volume&volume=${VOL:?}" \
  >> ${LOG_PATH:?} 2>&1                                      |\
  jq '.response' >> ${LOG_PATH:?}
