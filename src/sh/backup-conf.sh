#!/bin/sh
###############################################################################
#
# 引数で与えられたファイルを、~/backup-confにコピーする。
#
###############################################################################

for CONF in $*
do
  ABS_PATH=$(readlink -f $CONF)
  BACKUP=`echo $ABS_PATH | sed "s%/%#%g"`.bk`date '+%Y%m%d.%H%M%S'`
  cp -p $CONF $HOME/backup-conf/$BACKUP
  echo "$ABS_PATH -> $HOME/backup-conf/$BACKUP"
done
