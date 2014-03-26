#!/bin/sh
# SUMMARY:第一引数の秒数だけ、sleepし、第二引数以降のコマンドと引数をbgで実行し、そのプロセスidをkillする。

usage() {
  cat <<EOT
Usage
$ `basename $0` sleepsec command args [...]
EOT
}

if [ "$#" -eq "0" ]; then
  usage
  exit 1
fi

sec=$1	# 実行する秒数
shift

"$@" &	# bgで実行
PID=$!

sleep ${sec:?}
kill ${PID:?}

exit 0
