#!/bin/sh
# 
# EXPLANATION:explore solaris
#
#
LANG=C
name=`basename $0`
logd="/tmp"
#logf=${name:?}.`hostname`.`date +%Y%m%d.%H%M%S`.log
logf=${name:?}.`hostname`.log
log=${logd:?}/${logf:?}
echo ${name:?} > ${log:?}
echo ${log:?} >> ${log:?}
exec >> ${log:?}

main() {

  title 40 "ホスト名"
  run "hostname" hostname
  lcat /etc/inet/hosts
  lcat /etc/inet/ipnodes
  lcat /etc/hostname.*
  lcat /etc/net/ticlts/hosts
  lcat /etc/net/ticots/hosts
  lcat /etc/net/ticotsord/hosts

  title 40 "ノード名"
  run "uname -n" uname -n
  lcat /etc/nodename

  title 40 "メモリ"
  run "prtconf | grep -i mem" prtconf | grep -i mem

  title 40 "ＣＰＵ"
  run "prtdiag -v" /usr/platform/`uname -i`/sbin/prtdiag -v
  run "psrinfo -v" psrinfo -v

  title 40 "デバイス"
  run "iostat -En"  iostat -En
  title 40 "ディスク"
  run "format" format </dev/null
  title 40 "スワップ"
  run "swap -l" swap -l
  run "swap -s" swap -s

  title 40 "リリースレベル"
  run "uname -sr" uname -sr
  lcat  /etc/release

  title 40 "パッケージ"
  run "pkginfo" pkginfo -l

  title 40 "パッチ"
  run "patchadd" patchadd -p

  hl 40
  run "*/etc/vfstab" cat /etc/vfstab
  run "*/etc/dfs/dfstab" cat /etc/dfs/dfstab
  run "*/etc/dfs/sharetab" cat /etc/dfs/sharetab

  hl 40
  run "*mount"  mount

  hl 40
  run "*kernel"  ls -il /platform/`uname -m`/kernel
  hl 10
  run "*kernel module" modinfo

  hl 40
  run "*kernel parameter" sysdef -i
  hl 20
  run "*/etc/system" cat /etc/system
  run "*/etc/project" cat /etc/project

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
  run "ifconfig -a" ifconfig -a
  for dev in `ifconfig -a | grep '^[a-z]' | nawk '$1 !~ /lo/ {print $1;}' | sed "s/://"`
  do
    for option in link_speed link_status link_duplex link_autoneg 
    do
      run "ndd -get /dev/${dev:?} ${option:?}"  ndd -get /dev/${dev:?} ${option:?}
    done
  done
  hl 10
  run "*network" dladm show-link
  hl 10
  run "*network" dladm show-linkprop
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
  run "netmasks" cat /etc/inet/netmasks
  hl 40
  run "*gw" cat /etc/defaultrouter
  hl 40
  run "*route" netstat -rn

  hl 40
  run "*services" svcs -a
  hl 10
  echo "*services"
  run_inetadm

  hl 40
  run "*users" cat /etc/passwd
  run "*users" logins -x

  hl 40
  run "*groups" groups

  hl 40
  run "*locale" locale -a

  hl 40
  run "*auto_master" cat /etc/auto_master
  run "*auto_home" cat /etc/auto_home

  hl 40
  run "*Timezone" ls -l /etc/TIMEZONE /etc/default/init
  run "*Timezone" cat /etc/TIMEZONE

  hl 40
  #run "*find" find / -exec ls -ld {} \;
}

lcat() {
  for file in $@
  do
    hl 80
    ls -lai $file
    [ -f $file ] && cat $file
  done
}

hl() {
  COLS=$1
  nawk -v columns=$COLS 'BEGIN{for(i = 1; i <= columns; i++){printf("-");}printf("\n");}'
}

title() {
  COLS=$1; shift
  TITLE=$@
  nawk -v title="$TITLE" -v columns=$COLS \
    'BEGIN{
       for (i = 1; i <= columns; i++) {
         printf("**");
       }
       printf("\n**  %s  ", title);
       for (i = 1; i <= columns - length(title)/2 -3-1; i++) {
         printf("  ");
       }
       printf("**\n");
       for (i = 1; i <= columns; i++) {
         printf("**");
       }
       printf("\n");
   }'
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
  rc=$?
  if [ "${rc:?}" -ne "0" ];then
    echo "${command:?}'s status is ${rc:?}"
  fi
}

run_inetadm() {
  for fmri in `svcs | nawk\
                          '{ if ($1 == "online") {\
                               print $3;\
                             }\
                           }'`
  do
    if  inetadm -l ${fmri:?} > /tmp/${name:?}.$$.log 2>/dev/null; then
      hl 20
      echo ${fmri:?}
      cat /tmp/${name:?}.$$.log
    fi
    rm -f /tmp/${name:?}.$$.log
  done
}

main
rc=$?
exit $rc
