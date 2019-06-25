#!/bin/sh
###############################################################################
# EXPLANATION: sqlplus on docker
# DATE: 20190528
###############################################################################
# https://hub.docker.com/r/guywithnose/sqlplus/ 
# $ sudo docker pull guywithnose/sqlplus
#
#sudo docker run --rm -e NLS_LANG=American_Japan.AL32UTF8 --interactive guywithnose/sqlplus sqlplus system/L19GgnS3@w2016scan:1521/pdb00
#sudo docker run --rm -e NLS_LANG=Japanese_Japan.AL32UTF8 --interactive guywithnose/sqlplus sqlplus indou/indou@w2016scan:1521/orcl00

#sudo docker run --rm -e NLS_LANG=American_Japan.AL32UTF8 --interactive guywithnose/sqlplus sqlplus system/L19GgnS3@w2016scan:1521/orcl40p
#sudo docker run --rm -e NLS_LANG=American_Japan.AL32UTF8 --interactive guywithnose/sqlplus sqlplus sys/L19GgnS3@w2016scan:1521/orcl40p as sysdba
#sudo docker run --rm -e NLS_LANG=American_Japan.AL32UTF8 --interactive guywithnose/sqlplus sqlplus system/L19GgnS3@w2016scan:1521/orcl40p
#sudo docker run --rm -e NLS_LANG=American_Japan.AL32UTF8 --interactive guywithnose/sqlplus sqlplus system/L19GgnS3@192.168.0.124:15000/pdb00
#sudo docker run --rm -e NLS_LANG=American_Japan.AL32UTF8 --interactive guywithnose/sqlplus sqlplus system/L19GgnS3@w2016-1:15000/pdb00
#sudo docker run --rm -e NLS_LANG=American_Japan.AL32UTF8 --interactive guywithnose/sqlplus sqlplus system/L19GgnS3@w2016-2:16000/pdb00
#sudo docker run --rm -e NLS_LANG=American_Japan.AL32UTF8 --interactive guywithnose/sqlplus sqlplus system/L19GgnS3@w2016-1:15000/pdb00
#sudo docker run --rm -e NLS_LANG=American_Japan.AL32UTF8 --interactive guywithnose/sqlplus sqlplus system/L19GgnS3@w2016-2:16000/pdb00

OPTION=NLS_LANG=American_Japan.AL32UTF8
#UP="sys/L19GgnS3@w2016scan:1521/orcl40p as sysdba"
#UP="system/L19GgnS3@w2016scan:1521/orcl40p"
#UP="system/L19GgnS3@w2016-1:17040/orcl40p"
#UP="system/L19GgnS3@w2016-2:18040/orcl40p"
UP='system/Def$Leppard@w2012r2scan:1521/orcl'
UP='sys/Def$Leppard@w2012r2scan:1521/orcl as sysdba'

if [ "$1" != "" ]; then
  UP=$1
fi

echo $UP
sudo docker run --rm -e $OPTION --interactive guywithnose/sqlplus sqlplus ${UP:?}
