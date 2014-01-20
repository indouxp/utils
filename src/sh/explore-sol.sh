#!/bin/sh
#
#
name=`basename $0`
logd="/tmp"
#logf=${name:?}.`hostname`.`date +%Y%m%d.%H%M%S`.log
logf=${name:?}.`hostname`.log
log=${logd:?}/${logf:?}
echo ${name:?} > ${log:?}
echo ${log:?} >> ${log:?}
exec >> ${log:?}

main() {

  hl
  run "Host name" hostname

  hl
  run "Node name" uname -n

  hl
  cats  /etc/release

  hl
  run "lsb release" lsb_release -a

  hl
  run "server type" /usr/platform/`uname -i`/sbin/prtdiag -v
}

hl() {
  awk 'BEGIN{for(i = 1; i <= 40; i++){printf("-");}printf("\n");}'
}

run() {
  comment=$1
  echo ${comment:?}
  shift
  command=$1
  shift
  [ -x `which ${command:?}` ] && ${command:?} $@
}

cats() {
  for file in $@
  do
    ls -l ${file:?}
    [ -f ${file:?} ] && cat ${file:?}
  done
}

main
