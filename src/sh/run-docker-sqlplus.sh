#!/bin/sh
###############################################################################
#
# REFERENCE: https://github.com/oracle/docker-images/tree/master/OracleInstantClient
#
# cd docker-images/OracleInstantClient/dockerfiles
# sudo docker build -t oracle/instantclient:18.3.0 .
# sudo docker images
#REPOSITORY             TAG                 IMAGE ID            CREATED             SIZE
#oracle/instantclient   18.3.0              e7f268d04f26        2 hours ago         363MB
#oraclelinux            7-slim              f7512ac13c1b        11 days ago         118MB
#
###############################################################################
NAME=${0##*/}
DBNAME=$1
PORT=$2
SCAN=$3
USER=$4
PASS=$5

if [ "$#" -eq "0" ]; then
  cat <<EOT
Usage
  \$ ${NAME:?} DBNAME PORT SCAN(HOST) USER PASS
ex)
  \$ ${NAME:?} orcl00 1521 w2016scan system PASSWORD 
EOT
  exit 1
fi

#sudo docker \
#      run \
#      -e NLS_LANG=japanese_japan.utf8 \
#      -ti \
#      --rm \
#      oracle/instantclient:18.3.0 \
#      sqlplus -S system/L19GgnS3@w2016scan:1521/orcl00
sudo docker \
      run \
      -e NLS_LANG=japanese_japan.utf8 \
      -ti \
      --rm \
      oracle/instantclient:18.3.0 \
      sqlplus -S ${USER:?}/${PASS:?}@${SCAN:?}:${PORT:?}/${DBNAME:?}
RC=$?
exit ${RC:?}
