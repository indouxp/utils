#!/bin/sh
#
# https://hub.docker.com/r/guywithnose/sqlplus/ 
# $ sudo docker pull guywithnose/sqlplus
#
sudo docker run --rm -e NLS_LANG=American_Japan.AL32UTF8 --interactive guywithnose/sqlplus sqlplus indou/indou@w2016scan:1521/orcl00
#sudo docker run --rm -e NLS_LANG=Japanese_Japan.AL32UTF8 --interactive guywithnose/sqlplus sqlplus indou/indou@w2016scan:1521/orcl00
