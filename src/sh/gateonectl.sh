#!/bin/sh
NAME=${0##*/}

case "$1" in
start)
  nohup /opt/gateone/gateone.py &
  echo $! > ~/gateone.pid
  ;;
stop)
  PID=$(cat ~/gateone.pid)
  RC=$?
  if [ "${RC:?}" -eq "0" ]; then
    kill -KILL ${PID:?}
  else
    echo "${NAME:?}: fail." 1>&2
    exit 9
  fi
  ;;
*)
  exit 9
  ;;
esac
exit 0
