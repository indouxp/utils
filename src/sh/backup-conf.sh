#!/bin/sh
###############################################################################
#
# 引数で与えられたファイルを、~/backup-confにコピーする。
#
###############################################################################

for CONF in $*
do
  ABS_PATH=$(cd $(dirname $CONF) && pwd)/$(basename $CONF)
  BACKUP=`echo $ABS_PATH | sed "s%/%#%g"`.bk`date '+%Y%m%d.%H%M%S'`
  sudo cp -p $CONF $HOME/backup-conf.d/$BACKUP
  echo "$ABS_PATH -> $HOME/backup-conf.d/$BACKUP"
done
