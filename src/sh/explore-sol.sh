#!/bin/sh
# 
# EXPLANATION:explore solaris
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

  hl 40
  run "*Host name" hostname

  hl 40
  run "*Node name" uname -n

  hl 40
  run "*Server Release info" cat  /etc/release

  hl 40
  run "*operating system"  uname -a

  hl 40
  run "*memory" prtconf | grep -i mem

  hl 40
  run "*cpu" /usr/platform/`uname -i`/sbin/prtdiag -v

  hl 40
  run "*storage"  iostat -En

  hl 40
  run "*disk"  cat /etc/vfstab

  hl 40
  echo "format"
  format </dev/null

  hl 40
  run "*kernel"  ls -il /kernel/genunix
  run "*kernel"  ls -il /platform/`uname -m`/kernel
  hl 10
  run "*kernel module" modinfo

  hl 40
  run "*kernel parameter" sysdef -i

  hl 40
  run "*32 or 64"  isainfo -b

  hl 40
  run "*device driver" prtconf -D
  run "*device driver" sysdef

  hl 40
  run "*pagesize" pagesize

  hl 40
  run "*swap" swap -l
  run "*swap" swap -s

  hl 40
  run "*df" df -h

  hl 40
  run "*device driver" prtconf -D
  hl 10
  run "*device driver" sysdef

  hl 40
  run "*packages" pkginfo

  hl 40
  run "*patchs" patchadd -p

  hl 40
  run "*network" ifconfig -a
  hl 10
  run "*network" dladm show-link
  hl 10
  run "*network" dladm show-linkprop
  hl 10
  run "*network" dladm show-vnic
  hl 10
  run "*network" dladm show-etherstub
  hl 10
  run "*network" ipadm show-if
  hl 10
  run "*network" ipadm show-ifprop 
  hl 10
  run "*network" ipadm show-addr
  hl 10
  run "*network" ipadm show-addrprop

  hl 40
  run "*hosts" cat /etc/inet/hosts
  hl 40
  run "*gw" cat /etc/defaultrouter
  hl 40
  run "*route" netstat -rn

  hl 40
  run "*services" svcs -a
  hl 10
  run "*services" inetadm -l

  hl 40
  run "*users" cat /etc/passwd
  run "*users" logins -x

  hl 40
  run "*groups" groups

  hl 40
  run "find" find / -exec ls -ld {} \;
}

hl() {
  COL=$1
  nawk -v columns=$COL 'BEGIN{for(i = 1; i <= columns; i++){printf("-");}printf("\n");}'
}

run() {
  # 1:コメント
  # 2:コマンド
  # 3-:オプション
  comment=$1
  echo ${comment:?}
  shift
  command=$1
  shift
  [ -x `which ${command:?}` ] && ${command:?} $@
}

main
