#!/bin/sh
# SUMMARY:第二引数以降のコマンドと引数をbgで実行し、第一引数の秒数後、bgのプロセスをkillする。

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

sec=$1	# 第一引数は実行する秒数
shift

"$@" &	# 第二引数以降をbgで実行
PID=$!

sleep ${sec:?}
kill ${PID:?}

exit 0
