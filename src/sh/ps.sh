#!/bin/sh
###############################################################################
# description:
#
keyword=$1
case `uname -o || uname -s 2>/dev/null` in
FreeBSD)
  CMD="ps ax -o pid,ppid,uid,gid,%cpu,%mem,command"
  ;;
Darwin)
  CMD="ps -e -o pid,ppid,uid,gid,%cpu,%mem,command"
  ;;
*)
  exit 1
  ;;
esac

${CMD:?}            |
  grep ${keyword:?} |
  awk '
  BEGIN{
    printf("%-5s %-5s %-5s %-5s %-4s %-4s %s\n",
          "pid", "ppid", "uid", "gid", "cpu%", "mem%", "command");
  }
  {
#    print $0;
    str = "";
    for (i = 7; i <= NF; i++) {
      str = sprintf("%s %s", str, $i);
    }
    printf("%5d %5d %5d %5d %4.1f %4.1f %s\n",
          $1, $2, $3, $4, $5, $6, str);
  }'
exit $?    
