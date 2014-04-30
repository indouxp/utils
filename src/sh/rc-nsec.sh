#!/bin/sh
# SUMMARY:第二引数以降のコマンドと引数をbgで実行し、第一引数の秒数後、bgのプロセスをkillする。

SCRIPT=`basename $0`
LOGD="/tmp"
LOGF=`basename $0`.`hostname`.`date '+%Y%m%d.%H%M%S'`.log
LOG=${LOGD:?}/${LOGF:?}

usage() {
  cat <<EOT
Usage
$ `basename $0` sleepsec command [args ...]
EOT
}

if [ "$#" -eq "0" ]; then
  usage
  exit 1
fi

SEC=$1	# 第一引数は実行する秒数
shift

echo "$*"
"$*" &	# 第二引数以降をbgで実行
PID=$!

sleep ${SEC:?}
kill ${PID:?}

exit 0
