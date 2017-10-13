#!/bin/sh
###############################################################################
#
# /より、bkYYYYMMDD*を検索し、カレントディレクトリにバックアップし、
# オリジナルをコピーする。
#
###############################################################################

SCRIPT_DIR=$(cd $(dirname $0); pwd)

find / -name "*.bk[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]*" |
while read LINE
do
  DIR=`dirname ${LINE}`
  if echo ${DIR:?} | grep "/home/indou" > /dev/null
  then
    continue 
  fi
  if [ $DIR != $SCRIPT_DIR ]; then
    DEST=`echo $LINE | sed 's%/%@%g'`
    mv ${LINE:?} ${DEST:?}
    NOW=`echo ${LINE:?} | sed 's/\.bk[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9].*//'`
    DEST=`echo $NOW |sed 's%/%@%g'`
    cp -p ${NOW:?} ${DEST:?}
  fi
done
