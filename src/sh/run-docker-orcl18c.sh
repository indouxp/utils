#!/bin/sh
###############################################################################
#
# docker-images/OracleDatabase/SingleInstance/dockerfiles 
#
# tk2-259-39305上で、oracle 18cデータベースを動作させる
# Press Release: https://www.oracle.com/corporate/pressrelease/docker-oracle-041917.html
# github       : https://github.com/oracle/docker-images/tree/master/OracleDatabase
#

set -eu

ZIPFILE="LINUX.X64_180000_db_home.zip"
TERM() {
  mv ./18.3.0/${ZIPFILE:?} ~/work
}

if [ -e ~/work/${ZIPFILE:?} ]; then
  mv ~/work/${ZIPFILE:?} ./18.3.0
fi
trap 'TERM' 0 1 2 3 15

if ! docker images            |\
     grep "oracle/database"   |\
     grep "18\.3\.0-ee" > /dev/null
then
  ./buildDockerImage.sh -v 18.3.0 -e
fi

cat <<EOT
docker runします。
-p 1521:1521 しているので、ホスト上のsqlplus で接続可能です。
EOT

docker run                                        \
  --rm                                            \
  --name orcl18c                                  \
  -p 1521:1521                                    \
  -p 5500:5500                                    \
  -v /home/indou/work/oradata:/opt/oracle/oradata \
  -e ORACLE_SID=orcl18c                           \
  -e ORACLE_PDB=pdb18c                            \
  -e ORACLE_PWD=oracle                            \
  -e ORACLE_CHARACTERSET=AL32UTF8                 \
  --shm-size=1g                                   \
  oracle/database:18.3.0-ee
