#!/bin/sh
# 
# EXPLANATION:explore redhat linux
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
  lcat /etc/sysconfig/network

  title 40 "hw"
  run "lshw" lshw

  title 40 "メモリ"
  run "free -mt" free -mt
  lcat /proc/meminfo

  title 40 "ＣＰＵ"
  lcat /proc/cpuinfo

  title 40 "デバイス"
  run "fdisk -l"  fdisk -l
  run "swapon -s" swapon -s
  lcat /proc/swaps

  title 40 "リリースレベル"
  run "uname -sr" uname -sr
  lcat  /etc/redhat-release

  title 40 "パッケージ"
  run "rpm -qa" rpm -qa

  hl 40
  run "*/etc/fstab" cat /etc/fstab
#  run "*/etc/dfs/dfstab" cat /etc/dfs/dfstab
#  run "*/etc/dfs/sharetab" cat /etc/dfs/sharetab

  title 40 "マウント"
  hl 40
  run "*mount"  mount

  title 40 "カーネル"
  hl 40
  run "uname -r" uname -r
  hl 10
  title 40 "カーネルモジュール"
  run "lsmod" lsmod
  lcat /proc/modules
  lcat /etc/modprobe.conf 

  title 40 "カーネルパラメータ"
  hl 40
  run "sysctl -a" sysctl -a
  lcat `find /proc/sys/kernel/* -type f`
  lcat `find /proc/sys/fs/* -type f`
  lcat `find /proc/sys/vm/* -type f`
  lcat `find /proc/sys/net/* -type f`
  hl 40
  lcat /etc/sysctl.conf

  title 40 "ページサイズ"
  hl 40
  run " getconf PAGE_SIZE" getconf PAGE_SIZE


  hl 40
  run "ifconfig -a" ifconfig -a
  run "netstat -rn" netstat -an

  hl 40
  run "chkconfig --list" chkconfig --list

#  hl 40
#  run "*users" cat /etc/passwd
#  run "*users" logins -x
#
#  hl 40
#  run "*groups" groups
#
#  hl 40
#  run "*locale" locale -a
#
#  hl 40
#  run "*auto_master" cat /etc/auto_master
#  run "*auto_home" cat /etc/auto_home
#
#  hl 40
#  run "*Timezone" ls -l /etc/TIMEZONE /etc/default/init
#  run "*Timezone" cat /etc/TIMEZONE
#
#  hl 40
#  #run "*find" find / -exec ls -ld {} \;
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
  gawk -v columns=$COLS 'BEGIN{for(i = 1; i <= columns; i++){printf("-");}printf("\n");}'
}

title() {
  COLS=$1; shift
  TITLE=$@
  gawk -v title="$TITLE" -v columns=$COLS \
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
  for fmri in `svcs | gawk\
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
