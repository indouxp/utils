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
  if cp -p $CONF $HOME/backup-conf.d/$BACKUP; then
    echo "$ABS_PATH -> $HOME/backup-conf.d/$BACKUP done."
  else
    echo "$ABS_PATH -> $HOME/backup-conf.d/$BACKUP fail." 1>&2
    exit 1
  fi
done
exit 0
