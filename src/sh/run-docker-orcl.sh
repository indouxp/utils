#!/bin/sh
###############################################################################
#
# docker-images/OracleDatabase/SingleInstance/dockerfiles 
#
# tk2-259-39305上で、oracle 12.2データベースを動作させる
# Press Release: https://www.oracle.com/corporate/pressrelease/docker-oracle-041917.html
# github       : https://github.com/oracle/docker-images/tree/master/OracleDatabase
#

set -eu

ZIPFILE="linuxx64_12201_database.zip"
TERM() {
  mv ./12.2.0.1/${ZIPFILE:?} ~/work
}

if [ -e ~/work/${ZIPFILE:?} ]; then
  mv ~/work/${ZIPFILE:?} ./12.2.0.1
fi
trap 'TERM' 0 1 2 3 15

if ! docker images            |\
     grep "oracle/database"   |\
     grep "12\.2\.0\.1-ee" > /dev/null
then
  ./buildDockerImage.sh -v 12.2.0.1 -e
fi

cat <<EOT
docker runします。
-p 1521:1521 -p 5500:5500しているので、ホスト上のsqlplus で接続可能です。
EOT
cat ./12.2.0.1/oracle.env

docker run                                        \
  --rm                                            \
  --name orcl                                     \
  -p 1521:1521                                    \
  -p 5500:5500                                    \
  -v /home/indou/work/oradata:/opt/oracle/oradata \
  -e ORACLE_SID=orcl                              \
  -e ORACLE_PDB=pdb1                              \
  --shm-size=1g                                   \
  oracle/database:12.2.0.1-ee
