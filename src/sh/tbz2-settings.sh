#!/bin/sh
###############################################################################
# /から、*.bkYYYYMMDDを探し、バックアップします。
# by tsystem
###############################################################################
set -e
SCRIPT=`basename $0`

ID=`LANG=C id | sed "s/uid=\([0-9][0-9]*\)[^0-9]*.*/\1/"`
[ "${ID:?}" -eq "0" ] || exit 1 # uidが0でない場合は終了

timestamp=`date '+%Y%m%d%H%M%S'`
tar_dir=/tmp/${timestamp:?}

mkdir ${tar_dir:?}
if cd ${tar_dir:?}; then
  for file in `find / -name "*.bk[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]" | grep -v "^/tmp"`
  do
    dirname=`dirname ${file:?}`
    basename=`basename ${file:?}`
    original=`echo ${basename:?} | sed "s/\.bk[0-9][0-9][0-9][0-9][0-9][0-9][0-9][0-9]//"`
    prefix=`echo ${dirname:?} | sed "s%/%,%g"`
    cp -p ${file:?} ./${prefix:?},${basename:?}
    cp -p ${dirname:?}/${original:?} ./${prefix:?},${original:?}
  done
  cd ..
  tar cvf `hostname`.${timestamp:?}.tar ./${timestamp:?} && bzip2 `hostname`.${timestamp:?}.tar
fi

rm -r /tmp/${timestamp:?}
