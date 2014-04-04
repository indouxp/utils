#!/bin/sh
SERVER="192.168.0.254"

if ping -c 1 ${SERVER:?}; then
  [ -x /usr/sbin/ntpdate ] && sudo ntpdate ${SERVER:?}
  RC=$?
  if [ "${RC:?}" -eq "0" ]; then
    echo "ntpdate done." 1>&2
    [ -x /sbin/hwclock ] && sudo hwclock 
    RC=$?
    if [ "${RC:?}" -eq "0" ]; then
      echo "hwclock done" 1>&2
    else
      echo "hwclock fail." 1>&2
      exit ${RC:?}
    fi
  else
    echo "ntpdate fail." 1>&2
    exit ${RC:?}
  fi
else
  echo "ping fail." 1>&2
  exit ${RC:?}
fi
exit 0
	
