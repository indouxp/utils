#!/bin/sh
###############################################################################
#
# Product Introduction
#   引数1のファイルを、引数2のディレクトリ、もしくはカレントディレクトリに
#   バックアップする。
#
THIS_SCRIPT=`basename $0`
USAGE() {
  echo "#"
  sed -n '/^# Product Introduction/,/^#$/p' $0
  cat <<EOT
Usage
  # `basename $0` /PATH/FILE
  cp -p /PATH/FILE ./,PATH,FILE.bk`date '+%Y%m%d.%H%M%S'`

  # `basename $0` /PATH/FILE /root
  cp -p /PATH/FILE /root/,PATH,FILE.bk`date '+%Y%m%d.%H%M%S'`
EOT
}
if [ "$#" -eq "0" ]; then
  USAGE 1>&2
  exit 1
fi

if [ 1 -le $# ]; then
  FILE=$1
  if [ ! -r ${FILE:?} ]; then
    USAGE 1>&2
    exit 1
  fi
fi
DIR="."

if [ 2 -le $# ]; then
  DIR=$2
  if [ ! -d ${DIR:?} ]; then
    USAGE 1>&2
    exit 1
  fi
fi

NEW_FILE=`echo ${FILE:?} | sed "s#/#,#g"`
CMD="cp -p ${FILE:?} ${DIR:?}/${NEW_FILE:?}.bk`date '+%Y%m%d.%H%M%S'`"
${CMD:?}
RC=$?
if [ ${RC:?} -eq 0 ]; then
  echo "${THIS_SCRIPT:?}:${CMD:?} done."
fi

exit ${RC:?}
