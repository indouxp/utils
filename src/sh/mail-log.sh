#!/bin/sh
#
# /var/log以下のログをメール
#
#
NAME=`basename $0`
SUBJECT="`hostname`:`uname -s`:${NAME:?}:`date '+%Y%m%d.%H%M%S'`"
MAILTO="tatsuo-i@mtb.biglobe.ne.jp"

for file in           \
  /var/log/messages   \
  /var/log/syslog     \
  /var/log/daemon.log \
  /var/log/kern.log   \
  /var/log/dpkg.log   \
  /var/log/auth.log
do
  echo ${file:?}
  sed "s/^/  /" ${file:?} | tail -n 100
done | mail -s "${SUBJECT}" ${MAILTO:?}

